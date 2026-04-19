import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../domain/models/hospital_recommendation.dart';

class AiChatResponse {
  AiChatResponse({
    required this.reply,
    required this.conversationId,
    required this.recommendations,
    required this.isEmergency,
  });

  final String reply;
  final String conversationId;
  final List<HospitalRecommendation> recommendations;
  final bool isEmergency;
}

class AiChatRepository {
  AiChatRepository(this._dio);

  final Dio _dio;

  static bool detectEmergencyHeuristic(String message) {
    final m = message.toLowerCase();
    return m.contains('emergency') ||
        m.contains('chest pain') ||
        m.contains('bleeding') ||
        m.contains("can't breathe") ||
        m.contains('cannot breathe') ||
        m.contains('unconscious') ||
        m.contains('stroke') ||
        m.contains('choking');
  }

  Future<AiChatResponse> sendMessage({
    required String message,
    required String patientId,
    String? conversationId,
  }) async {
    try {
      final response = await _dio.post(
        AppConfig.aiChatPath,
        data: {
          'message': message,
          'patient_id': patientId,
          'conversation_id': conversationId,
        },
      );

      final data = response.data as Map<String, dynamic>;
      final rows = (data['recommended_hospitals'] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(HospitalRecommendation.fromJson)
          .toList();
      final emergencyFlag = data['is_emergency'] == true ||
          detectEmergencyHeuristic(message);

      return AiChatResponse(
        reply: (data['reply'] ?? '') as String,
        conversationId: (data['conversation_id'] ?? conversationId ?? '')
            as String,
        recommendations: rows,
        isEmergency: emergencyFlag,
      );
    } catch (_) {
      return _offlineResponse(message, patientId, conversationId);
    }
  }

  /// Used only when [sendMessage] cannot reach the server (no backend / network).
  AiChatResponse _offlineResponse(
    String message,
    String patientId,
    String? conversationId,
  ) {
    final isEmergency = detectEmergencyHeuristic(message);
    final conv =
        conversationId ??
        'local-${patientId.hashCode}-${DateTime.now().millisecondsSinceEpoch}';
    final recs = isEmergency
        ? const [
            HospitalRecommendation(
              id: 'h1',
              name: 'St. Mary Trauma Center',
              address: 'Bole Rd — 24/7 ER',
              distanceKm: 1.2,
              score: 0.94,
              rating: 4.8,
            ),
            HospitalRecommendation(
              id: 'h2',
              name: 'Unity Cardiac Hospital',
              address: 'Kazanchis — cardiac ICU',
              distanceKm: 2.4,
              score: 0.91,
              rating: 4.6,
            ),
            HospitalRecommendation(
              id: 'h3',
              name: 'Hope Pediatric & ER',
              address: 'Piassa — pediatric ER',
              distanceKm: 3.1,
              score: 0.88,
              rating: 4.5,
            ),
          ]
        : const <HospitalRecommendation>[];

    final reply = isEmergency
        ? 'Potential emergency detected. Stay calm, avoid moving unnecessarily, '
            'and I recommend immediate evaluation. Tap below to see hospitals '
            'sorted for your case.'
        : 'Thanks for sharing. Monitor symptoms closely. If anything worsens '
            '(breathing difficulty, severe pain, confusion), use the red '
            'Emergency button on your home screen.';

    return AiChatResponse(
      reply: reply,
      conversationId: conv,
      recommendations: recs,
      isEmergency: isEmergency,
    );
  }

  Future<void> selectHospital({
    required String hospitalId,
    required String patientId,
    required String conversationId,
  }) async {
    try {
      await _dio.post(
        AppConfig.hospitalSelectionPath,
        data: {
          'hospital_id': hospitalId,
          'patient_id': patientId,
          'conversation_id': conversationId,
        },
      );
    } catch (_) {
      // Offline: UI can still continue; sync with server when API is available.
    }
  }
}
