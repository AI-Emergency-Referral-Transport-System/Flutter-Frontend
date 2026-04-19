import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/notification_repository.dart';
import '../../domain/models/notification_item.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository) : super(const NotificationsState());

  final NotificationRepository _repository;

  Future<void> loadNotifications() async {
    emit(
      state.copyWith(
        status: NotificationsStatus.loading,
        clearError: true,
      ),
    );
    try {
      final remote = await _repository.fetchRemote();
      final merged = [...remote, ...state.localOnly];
      merged.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(
        state.copyWith(
          status: NotificationsStatus.success,
          notifications: _dedupe(merged),
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationsStatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void pushLocal(NotificationItem item) {
    final next = [item, ...state.notifications];
    emit(
      state.copyWith(
        notifications: _dedupe(next),
        localOnly: [item, ...state.localOnly],
      ),
    );
  }

  void markRead(NotificationItem item) {
    final updated = state.notifications
        .map((n) => n.id == item.id ? n.copyWith(isRead: true) : n)
        .toList();
    emit(state.copyWith(notifications: updated));
  }

  List<NotificationItem> _dedupe(List<NotificationItem> items) {
    final seen = <String>{};
    final out = <NotificationItem>[];
    for (final n in items) {
      if (seen.add(n.id)) out.add(n);
    }
    return out;
  }
}
