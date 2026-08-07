import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:subzero/feature/notification/model/notification_model.dart';
import 'package:subzero/feature/notification/presentation/cubit/notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(const NotificationState()) {
    load();
  }

  static const int _pageSize = 10;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DocumentSnapshot<Map<String, dynamic>>? _lastDocument;

  Query<Map<String, dynamic>> _notificationsQuery(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true);
  }

  Future<void> load() async {
    final user = _auth.currentUser;

    if (user == null) {
      _lastDocument = null;

      emit(
        state.copyWith(
          loading: false,
          loadingMore: false,
          hasMore: false,
          notifications: [],
          clearError: true,
        ),
      );

      return;
    }

    _lastDocument = null;

    emit(
      state.copyWith(
        loading: true,
        loadingMore: false,
        hasMore: true,
        notifications: [],
        clearError: true,
      ),
    );

    try {
      final snapshot = await _notificationsQuery(
        user.uid,
      ).limit(_pageSize + 1).get();

      final hasMore = snapshot.docs.length > _pageSize;

      final visibleDocuments = snapshot.docs.take(_pageSize).toList();

      final notifications = visibleDocuments
          .map(AppNotificationModel.fromDoc)
          .toList();

      _lastDocument = visibleDocuments.isEmpty ? null : visibleDocuments.last;

      emit(
        state.copyWith(
          loading: false,
          loadingMore: false,
          hasMore: hasMore,
          notifications: notifications,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          loading: false,
          loadingMore: false,
          hasMore: false,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final user = _auth.currentUser;

    if (user == null ||
        state.loading ||
        state.loadingMore ||
        !state.hasMore ||
        _lastDocument == null) {
      return;
    }

    emit(state.copyWith(loadingMore: true, clearError: true));

    try {
      final snapshot = await _notificationsQuery(
        user.uid,
      ).startAfterDocument(_lastDocument!).limit(_pageSize + 1).get();

      final hasMore = snapshot.docs.length > _pageSize;

      final visibleDocuments = snapshot.docs.take(_pageSize).toList();

      final newNotifications = visibleDocuments
          .map(AppNotificationModel.fromDoc)
          .toList();

      if (visibleDocuments.isNotEmpty) {
        _lastDocument = visibleDocuments.last;
      }

      emit(
        state.copyWith(
          loadingMore: false,
          hasMore: hasMore,
          notifications: [...state.notifications, ...newNotifications],
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(loadingMore: false, errorMessage: error.toString()));
    }
  }

  Future<void> refresh() async {
    await load();
  }

  Future<void> markAllAsSeen() async {
    final user = _auth.currentUser;

    if (user == null) return;

    final userRef = _firestore.collection('users').doc(user.uid);

    try {
      final unreadSnapshot = await userRef
          .collection('notifications')
          .where('isSeen', isEqualTo: false)
          .get();

      final batch = _firestore.batch();

      for (final document in unreadSnapshot.docs) {
        batch.update(document.reference, {
          'isSeen': true,
          'seenAt': FieldValue.serverTimestamp(),
        });
      }

      batch.set(userRef, {
        'hasUnreadNotifications': false,
        'unreadNotificationCount': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();

      _markLoadedNotificationsAsSeen();
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  void _markLoadedNotificationsAsSeen() {
    final updatedNotifications = state.notifications
        .map((notification) => notification.copyWith(isSeen: true))
        .toList();

    emit(state.copyWith(notifications: updatedNotifications));
  }
}
