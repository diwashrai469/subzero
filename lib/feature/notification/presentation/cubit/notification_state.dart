import 'package:subzero/feature/notification/model/notification_model.dart';

class NotificationState {
  const NotificationState({
    this.loading = false,
    this.notifications = const [],
  });

  final bool loading;
  final List<AppNotificationModel> notifications;

  NotificationState copyWith({
    bool? loading,
    List<AppNotificationModel>? notifications,
  }) {
    return NotificationState(
      loading: loading ?? this.loading,
      notifications: notifications ?? this.notifications,
    );
  }
}
