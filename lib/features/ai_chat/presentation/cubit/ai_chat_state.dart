part of 'ai_chat_cubit.dart';

class AiChatState extends Equatable {
  const AiChatState({
    this.messages = const [],
    this.recommendations = const [],
    this.conversationId = '',
    this.isSending = false,
    this.selectingHospitalId,
    this.selectedHospital,
    this.errorMessage,
    this.lastResponseEmergency = false,
  });

  final List<ChatMessage> messages;
  final List<HospitalRecommendation> recommendations;
  final String conversationId;
  final bool isSending;
  final String? selectingHospitalId;
  final HospitalRecommendation? selectedHospital;
  final String? errorMessage;
  final bool lastResponseEmergency;

  bool get showHospitalCta =>
      lastResponseEmergency && recommendations.isNotEmpty;

  AiChatState copyWith({
    List<ChatMessage>? messages,
    List<HospitalRecommendation>? recommendations,
    String? conversationId,
    bool? isSending,
    String? selectingHospitalId,
    HospitalRecommendation? selectedHospital,
    String? errorMessage,
    bool? lastResponseEmergency,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      recommendations: recommendations ?? this.recommendations,
      conversationId: conversationId ?? this.conversationId,
      isSending: isSending ?? this.isSending,
      selectingHospitalId: selectingHospitalId,
      selectedHospital: selectedHospital ?? this.selectedHospital,
      errorMessage: errorMessage,
      lastResponseEmergency:
          lastResponseEmergency ?? this.lastResponseEmergency,
    );
  }

  @override
  List<Object?> get props => [
    messages,
    recommendations,
    conversationId,
    isSending,
    selectingHospitalId,
    selectedHospital,
    errorMessage,
    lastResponseEmergency,
  ];
}
