import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import 'package:subzero/feature/notification/model/notification_model.dart';
import 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState()) {
    load();
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _notificationStream;

  Future<void> load() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      emit(state.copyWith(loading: false, notifications: []));
      return;
    }

    await _notificationStream?.cancel();

    emit(state.copyWith(loading: true));

    _notificationStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            final notifications = snapshot.docs
                .map(AppNotificationModel.fromDoc)
                .toList();

            emit(state.copyWith(loading: false, notifications: notifications));
          },
          onError: (_) {
            emit(state.copyWith(loading: false));
          },
        );
  }

  Future<void> markAllAsSeen() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final unreadSnapshot = await userRef
        .collection('notifications')
        .where('isSeen', isEqualTo: false)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in unreadSnapshot.docs) {
      batch.update(doc.reference, {
        'isSeen': true,
        'seenAt': FieldValue.serverTimestamp(),
      });
    }

    batch.update(userRef, {
      'hasUnreadNotifications': false,
      'unreadNotificationCount': 0,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  Future<void> close() async {
    await _notificationStream?.cancel();
    return super.close();
  }
}
