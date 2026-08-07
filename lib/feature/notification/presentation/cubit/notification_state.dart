import 'package:subzero/feature/notification/model/notification_model.dart';

class NotificationState {
  const NotificationState({
    this.loading = false,
    this.loadingMore = false,
    this.hasMore = true,
    this.notifications = const [],
    this.errorMessage,
  });

  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final List<AppNotificationModel> notifications;
  final String? errorMessage;

  NotificationState copyWith({
    bool? loading,
    bool? loadingMore,
    bool? hasMore,
    List<AppNotificationModel>? notifications,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      notifications: notifications ?? this.notifications,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
