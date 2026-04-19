import 'package:equatable/equatable.dart';

enum NotificationChannel { emergency, trip, request, general }

class NotificationItem extends Equatable {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
    this.channel = NotificationChannel.general,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;
  final NotificationChannel channel;

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      channel: channel,
    );
  }

  @override
  List<Object?> get props => [id, title, body, createdAt, isRead, channel];
}
