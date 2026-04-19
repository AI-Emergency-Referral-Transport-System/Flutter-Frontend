part of 'trip_cubit.dart';

enum TripPhase {
  none,
  awaitingDriverAcceptance,
  driverEnRouteToPatient,
  arrivedAtPatient,
  patientPickedUp,
  arrivedAtHospital,
  completed,
}

enum TripRequestStatus { pending, accepted }

class DriverTripRequest extends Equatable {
  const DriverTripRequest({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.summary,
    required this.hospital,
    required this.createdAt,
    this.conversationId,
    this.status = TripRequestStatus.pending,
  });

  final String id;
  final String patientName;
  final String patientId;
  final String summary;
  final HospitalRecommendation hospital;
  final DateTime createdAt;
  final String? conversationId;
  final TripRequestStatus status;

  DriverTripRequest copyWith({TripRequestStatus? status}) {
    return DriverTripRequest(
      id: id,
      patientName: patientName,
      patientId: patientId,
      summary: summary,
      hospital: hospital,
      createdAt: createdAt,
      conversationId: conversationId,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    patientName,
    patientId,
    summary,
    hospital,
    createdAt,
    conversationId,
    status,
  ];
}

class TripState extends Equatable {
  const TripState({
    this.phase = TripPhase.none,
    this.openRequests = const [],
    this.activeRequestId,
    this.activeHospital,
    this.activePatientName,
    this.activePatientId,
    this.activePatientSummary,
    this.activeConversationId,
  });

  final TripPhase phase;
  final List<DriverTripRequest> openRequests;
  final String? activeRequestId;
  final HospitalRecommendation? activeHospital;
  final String? activePatientName;
  final String? activePatientId;
  final String? activePatientSummary;
  final String? activeConversationId;

  bool get hasLiveTrip =>
      phase != TripPhase.none &&
      phase != TripPhase.completed &&
      phase != TripPhase.awaitingDriverAcceptance;

  bool get awaitingDriver =>
      phase == TripPhase.awaitingDriverAcceptance ||
      (phase == TripPhase.driverEnRouteToPatient && activeRequestId != null);

  TripState copyWith({
    TripPhase? phase,
    List<DriverTripRequest>? openRequests,
    String? activeRequestId,
    HospitalRecommendation? activeHospital,
    String? activePatientName,
    String? activePatientId,
    String? activePatientSummary,
    String? activeConversationId,
  }) {
    return TripState(
      phase: phase ?? this.phase,
      openRequests: openRequests ?? this.openRequests,
      activeRequestId: activeRequestId ?? this.activeRequestId,
      activeHospital: activeHospital ?? this.activeHospital,
      activePatientName: activePatientName ?? this.activePatientName,
      activePatientId: activePatientId ?? this.activePatientId,
      activePatientSummary:
          activePatientSummary ?? this.activePatientSummary,
      activeConversationId:
          activeConversationId ?? this.activeConversationId,
    );
  }

  @override
  List<Object?> get props => [
    phase,
    openRequests,
    activeRequestId,
    activeHospital,
    activePatientName,
    activePatientId,
    activePatientSummary,
    activeConversationId,
  ];
}
