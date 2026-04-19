import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../domain/models/notification_item.dart';

class NotificationRepository {
  NotificationRepository(this._dio);

  final Dio _dio;

  Future<List<NotificationItem>> fetchRemote() async {
    try {
      final res = await _dio.get(AppConfig.notificationsPath);
      final list = res.data;
      if (list is! List) return const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(_fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  NotificationItem _fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      title: (json['title'] ?? 'Update') as String,
      body: (json['body'] ?? '') as String,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      isRead: json['is_read'] == true,
      channel: NotificationChannel.general,
    );
  }
}
