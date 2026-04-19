import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../cubit/notifications_cubit.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.status == NotificationsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == NotificationsStatus.failure) {
            return Center(
              child: Text(
                state.error ?? 'Error',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state.notifications.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<NotificationsCubit>().loadNotifications(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = state.notifications[index];
                final timeLabel = DateFormat(
                  'MMM d, h:mm a',
                ).format(item.createdAt);

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () =>
                      context.read<NotificationsCubit>().markRead(item),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: item.isRead
                          ? Colors.white
                          : const Color(0xFFEAF8FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD7EAF5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (!item.isRead)
                              const CircleAvatar(
                                radius: 4,
                                backgroundColor: Color(0xFF00B85C),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(item.body),
                        const SizedBox(height: 8),
                        Text(
                          timeLabel,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
