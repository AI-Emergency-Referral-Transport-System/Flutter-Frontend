part of 'notifications_cubit.dart';

enum NotificationsStatus { initial, loading, success, failure }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.notifications = const [],
    this.localOnly = const [],
    this.error,
  });

  final NotificationsStatus status;
  final List<NotificationItem> notifications;
  final List<NotificationItem> localOnly;
  final String? error;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<NotificationItem>? notifications,
    List<NotificationItem>? localOnly,
    String? error,
    bool clearError = false,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      localOnly: localOnly ?? this.localOnly,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [status, notifications, localOnly, error];
}
