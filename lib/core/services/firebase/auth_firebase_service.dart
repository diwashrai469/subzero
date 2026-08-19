import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:subzero/core/pro/cubit/pro_cubit.dart';
import 'package:subzero/core/pro/service/pro_services.dart';

import 'package:subzero/core/services/firebase/fcm_service.dart';

enum SubzeroAuthResult { signedIn, failed, cancelled }

@lazySingleton
class AuthFirebaseService {
  AuthFirebaseService(this._auth, this._db, this._proService, this._proCubit);

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final ProService _proService;
  final ProCubit _proCubit;

  Future<SubzeroAuthResult> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        debugPrint('⚠️ Google sign-in cancelled by user');
        return SubzeroAuthResult.cancelled;
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

      await _afterSuccessfulSignIn(user);

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

  Future<SubzeroAuthResult> signInWithApple() async {
    try {
      final rawNonce = _generateNonce();
      final hashedNonce = _sha256OfString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final identityToken = appleCredential.identityToken;
      final authorizationCode = appleCredential.authorizationCode;

      if (identityToken == null || identityToken.isEmpty) {
        debugPrint('❌ Apple sign-in returned empty identity token');
        return SubzeroAuthResult.failed;
      }

      if (authorizationCode.isEmpty) {
        debugPrint('❌ Apple sign-in returned empty authorization code');
        return SubzeroAuthResult.failed;
      }

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: identityToken,
        accessToken: authorizationCode,
        rawNonce: rawNonce,
      );

      final userCredential = await _auth.signInWithCredential(oauthCredential);
      final user = userCredential.user;

      if (user == null) {
        debugPrint('❌ Apple sign-in returned null user');
        return SubzeroAuthResult.failed;
      }

      await _updateAppleDisplayNameIfNeeded(
        user: user,
        appleCredential: appleCredential,
      );

      await _afterSuccessfulSignIn(_auth.currentUser ?? user);

      debugPrint('✅ Signed in with Apple: ${user.uid}');
      return SubzeroAuthResult.signedIn;
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint('❌ Apple authorization failed: ${e.code} - ${e.message}');

      if (e.code == AuthorizationErrorCode.canceled) {
        return SubzeroAuthResult.cancelled;
      }

      return SubzeroAuthResult.failed;
    } on FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase Apple sign-in failed: ${e.code} - ${e.message}');
      return SubzeroAuthResult.failed;
    } catch (e) {
      debugPrint('❌ Apple sign-in failed: $e');
      return SubzeroAuthResult.failed;
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      debugPrint('⚠️ Google sign-out failed: $e');
    }

    await Purchases.logOut();

    await _auth.signOut();
  }

  Future<void> _afterSuccessfulSignIn(User user) async {
    await _upsertUserDocument(user);
    await FCMService.saveTokenForCurrentUser();

    await _proService.login(user.uid);
    await _proCubit.loadProStatus();
  }

  Future<void> _updateAppleDisplayNameIfNeeded({
    required User user,
    required AuthorizationCredentialAppleID appleCredential,
  }) async {
    final firstName = appleCredential.givenName?.trim();
    final lastName = appleCredential.familyName?.trim();

    final fullName = [
      if (firstName != null && firstName.isNotEmpty) firstName,
      if (lastName != null && lastName.isNotEmpty) lastName,
    ].join(' ').trim();

    if (fullName.isEmpty) return;

    final currentDisplayName = user.displayName?.trim();

    if (currentDisplayName != null && currentDisplayName.isNotEmpty) return;

    await user.updateDisplayName(fullName);
    await user.reload();
  }

  Future<void> _upsertUserDocument(User user) async {
    final latestUser = _auth.currentUser ?? user;
    final userRef = _db.collection('users').doc(latestUser.uid);
    final snapshot = await userRef.get();

    final providerIds = latestUser.providerData
        .map((provider) => provider.providerId)
        .toList();

    await userRef.set({
      'uid': latestUser.uid,
      'email': latestUser.email,
      'displayName': latestUser.displayName,
      'photoUrl': latestUser.photoURL,
      'isAnonymous': false,
      'providers': providerIds,
      if (!snapshot.exists) 'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

    final random = Random.secure();

    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256OfString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);

    return digest.toString();
  }
}
