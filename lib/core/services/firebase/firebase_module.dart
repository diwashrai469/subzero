import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@module
abstract class FirebaseModule {
  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
}

@injectable
class SubscriptionFirebaseService {
  SubscriptionFirebaseService(this._db, this._auth);

  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  String get _uid {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('No user found. Sign in as guest or user first.');
    }

    return user.uid;
  }

  Future<void> removeFcmToken(String token) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        debugPrint('⚠️ Cannot remove FCM token because no user is signed in.');
        return;
      }

      await _db
          .collection('users')
          .doc(user.uid)
          .collection('fcmTokens')
          .doc(token)
          .delete();

      debugPrint('🗑️ FCM token removed for user: ${user.uid}');
    } catch (e) {
      debugPrint('❌ removeFcmToken error: $e');
    }
  }

  Future<void> saveFcmToken(String token) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        debugPrint(
          '⚠️ Cannot save FCM token because user is not signed in yet.',
        );
        return;
      }

      await _db
          .collection('users')
          .doc(user.uid)
          .collection('fcmTokens')
          .doc(token)
          .set({
            'token': token,
            'platform': defaultTargetPlatform.name,
            'isAnonymous': user.isAnonymous,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      await _db.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'isAnonymous': user.isAnonymous,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('✅ FCM token saved in Firestore');
    } catch (e) {
      debugPrint('❌ saveFcmToken error: $e');
    }
  }

  Future<void> saveSubscription({
    required String id,
    required String name,
    required double amount,
    required String currency,
    required String currencyCode,
    required String billingCycle,
    required String category,
    required DateTime firstBillDate,
    required DateTime nextBillDate,
    required double totalTillDate,
    required List<int> reminderDays,
    String? cancelUrl,
  }) async {
    try {
      final uid = _uid;

      final docRef = _db
          .collection('users')
          .doc(uid)
          .collection('subscriptions')
          .doc(id);

      final snapshot = await docRef.get();

      await docRef.set({
        'id': id,
        'name': name,
        'amount': amount,
        'currency': currency,
        'currencyCode': currencyCode,
        'billingCycle': billingCycle,
        'category': category,
        'firstBillDate': Timestamp.fromDate(firstBillDate),
        'nextBillDate': Timestamp.fromDate(nextBillDate),
        'reminderDays': reminderDays,
        'cancelUrl': cancelUrl,

        // Only set totalTillDate when creating a new subscription.
        if (!snapshot.exists) 'totalTillDate': totalTillDate,

        if (!snapshot.exists) 'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('❌ saveSubscription error: $e');
      rethrow;
    }
  }

  Future<void> deleteSubscription({required String id}) async {
    try {
      final uid = _uid;

      await _db
          .collection('users')
          .doc(uid)
          .collection('subscriptions')
          .doc(id)
          .delete();
    } catch (e) {
      debugPrint('❌ deleteSubscription error: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> subscriptionStream() {
    final uid = _uid;

    return _db
        .collection('users')
        .doc(uid)
        .collection('subscriptions')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
}
