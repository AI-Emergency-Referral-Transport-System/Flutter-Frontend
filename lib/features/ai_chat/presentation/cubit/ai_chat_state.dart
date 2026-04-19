part of 'ai_chat_cubit.dart';

class AiChatState extends Equatable {
  const AiChatState({
    this.messages = const [],
    this.recommendations = const [],
    this.transportRecommendations = const [],
    this.conversationId = '',
    this.isSending = false,
    this.selectingHospitalId,
    this.selectedHospital,
    this.errorMessage,
    this.lastResponseEmergency = false,
  });

  final List<ChatMessage> messages;
  final List<HospitalRecommendation> recommendations;
  final List<TransportRecommendation> transportRecommendations;
  final String conversationId;
  final bool isSending;
  final String? selectingHospitalId;
  final HospitalRecommendation? selectedHospital;
  final String? errorMessage;
  final bool lastResponseEmergency;

  bool get showHospitalCta =>
      lastResponseEmergency &&
      (recommendations.isNotEmpty || transportRecommendations.isNotEmpty);

  AiChatState copyWith({
    List<ChatMessage>? messages,
    List<HospitalRecommendation>? recommendations,
    List<TransportRecommendation>? transportRecommendations,
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
      transportRecommendations:
          transportRecommendations ?? this.transportRecommendations,
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
    transportRecommendations,
    conversationId,
    isSending,
    selectingHospitalId,
    selectedHospital,
    errorMessage,
    lastResponseEmergency,
  ];
}
