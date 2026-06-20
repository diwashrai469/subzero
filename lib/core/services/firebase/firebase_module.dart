import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@module
abstract class FirebaseModule {
  @lazySingleton
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}

@injectable
class SubscriptionFirebaseService {
  final FirebaseFirestore _db;
  final FlutterSecureStorage _storage;

  SubscriptionFirebaseService(this._db, this._storage);

  String? _cachedUserId;

  Future<String> get userId async {
    if (_cachedUserId != null) return _cachedUserId!;

    String? id = await _storage.read(key: 'device_id');

    if (id == null) {
      id = const Uuid().v4();
      await _storage.write(key: 'device_id', value: id);
    }

    _cachedUserId = id;
    return id;
  }

  Future<void> saveFcmToken(String token) async {
    try {
      final uid = await userId;

      await _db.collection('users').doc(uid).set({
        'fcmToken': token,
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
    required String billingCycle,
    required String category,
    required DateTime firstBillDate,
    required DateTime nextBillDate,
    String? cancelUrl,
  }) async {
    try {
      final uid = await userId;

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
        'billingCycle': billingCycle,
        'category': category,
        'firstBillDate': Timestamp.fromDate(firstBillDate),
        'nextBillDate': Timestamp.fromDate(nextBillDate),
        'cancelUrl': cancelUrl,
        if (!snapshot.exists) 'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('❌ saveSubscription error: $e');
    }
  }

  Future<void> deleteSubscription({required String id}) async {
    try {
      final uid = await userId;

      await _db
          .collection('users')
          .doc(uid)
          .collection('subscriptions')
          .doc(id)
          .delete();
    } catch (e) {
      debugPrint('❌ deleteSubscription error: $e');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> subscriptionStream() async* {
    final uid = await userId;

    yield* _db
        .collection('users')
        .doc(uid)
        .collection('subscriptions')
        .orderBy('updatedAt', descending: true)
        .snapshots();
  }
}
