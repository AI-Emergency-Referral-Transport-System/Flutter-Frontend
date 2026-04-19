import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/ai_chat_repository.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/hospital_recommendation.dart';
import '../../domain/models/transport_recommendation.dart';

part 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  AiChatCubit(this._repository) : super(const AiChatState());

  final AiChatRepository _repository;

  static const String _defaultPatientId = 'anonymous';

  Future<void> sendMessage(String message, {String? patientId}) async {
    if (message.trim().isEmpty) return;
    final resolvedPatient = patientId ?? _defaultPatientId;
    final userMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: message.trim(),
      isMine: true,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, userMessage];
    emit(state.copyWith(isSending: true, messages: updatedMessages));

    try {
      final response = await _repository.sendMessage(
        message: message.trim(),
        patientId: resolvedPatient,
        conversationId: state.conversationId.isEmpty
            ? null
            : state.conversationId,
      );

      final aiMessage = ChatMessage(
        id: DateTime.now()
            .add(const Duration(milliseconds: 1))
            .microsecondsSinceEpoch
            .toString(),
        text: response.reply,
        isMine: false,
        timestamp: DateTime.now(),
      );

      emit(
        state.copyWith(
          isSending: false,
          conversationId: response.conversationId,
          recommendations: response.recommendations,
          transportRecommendations: response.transportRecommendations,
          messages: [...updatedMessages, aiMessage],
          errorMessage: null,
          lastResponseEmergency: response.isEmergency,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSending: false,
          errorMessage: 'Failed to send message.',
          messages: updatedMessages,
        ),
      );
    }
  }

  Future<void> selectHospital(
    HospitalRecommendation hospital, {
    String? patientId,
  }) async {
    emit(state.copyWith(selectingHospitalId: hospital.id, errorMessage: null));
    try {
      await _repository.selectHospital(
        hospitalId: hospital.id,
        patientId: patientId ?? _defaultPatientId,
        conversationId: state.conversationId,
      );
      emit(
        state.copyWith(selectingHospitalId: null, selectedHospital: hospital),
      );
    } catch (_) {
      emit(
        state.copyWith(
          selectingHospitalId: null,
          errorMessage: 'Could not submit selected hospital.',
        ),
      );
    }
  }
}
