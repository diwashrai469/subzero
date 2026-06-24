import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import 'package:subzero/core/services/firebase/fcm_service.dart';

enum SubzeroAuthResult { signedIn, failed }

@lazySingleton
class AuthFirebaseService {
  AuthFirebaseService(this._auth, this._db);

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  Future<SubzeroAuthResult> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        debugPrint('⚠️ Google sign-in cancelled by user');
        return SubzeroAuthResult.failed;
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        debugPrint('❌ Google sign-in returned null user');
        return SubzeroAuthResult.failed;
      }

      await _upsertUserDocument(user);
      await FCMService.saveTokenForCurrentUser();

      debugPrint('✅ Signed in with Google: ${user.uid}');
      return SubzeroAuthResult.signedIn;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Google sign-in failed: ${e.code} - ${e.message}');
      return SubzeroAuthResult.failed;
    } catch (e) {
      debugPrint('❌ Google sign-in failed: $e');
      return SubzeroAuthResult.failed;
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint('⚠️ Google sign-out failed: $e');
    }

    await _auth.signOut();
  }

  Future<void> _upsertUserDocument(User user) async {
    final userRef = _db.collection('users').doc(user.uid);
    final snapshot = await userRef.get();

    final providerIds = user.providerData
        .map((provider) => provider.providerId)
        .toList();

    await userRef.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'isAnonymous': false,
      'providers': providerIds,
      if (!snapshot.exists) 'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
