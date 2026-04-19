import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../ai_chat/domain/models/hospital_recommendation.dart';

part 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit() : super(const TripState());

  void resetTrip() {
    emit(const TripState());
  }

  String createOpenRequest({
    required String patientName,
    required String patientId,
    required String summary,
    required HospitalRecommendation hospital,
    String? conversationId,
  }) {
    final id = 'req-${DateTime.now().millisecondsSinceEpoch}';
    final req = DriverTripRequest(
      id: id,
      patientName: patientName,
      patientId: patientId,
      summary: summary,
      hospital: hospital,
      conversationId: conversationId,
      createdAt: DateTime.now(),
    );
    emit(
      state.copyWith(
        openRequests: [...state.openRequests, req],
        activePatientSummary: summary,
        activeHospital: hospital,
        activePatientName: patientName,
        activePatientId: patientId,
        activeConversationId: conversationId,
        phase: TripPhase.awaitingDriverAcceptance,
      ),
    );
    return id;
  }

  void driverAccept(String requestId) {
    final list = [...state.openRequests];
    final idx = list.indexWhere((e) => e.id == requestId);
    if (idx == -1) return;
    final accepted = list[idx].copyWith(status: TripRequestStatus.accepted);
    list[idx] = accepted;
    emit(
      state.copyWith(
        openRequests: list,
        activeRequestId: requestId,
        phase: TripPhase.driverEnRouteToPatient,
      ),
    );
  }

  void driverDecline(String requestId) {
    emit(
      state.copyWith(
        openRequests: state.openRequests
            .where((e) => e.id != requestId)
            .toList(),
      ),
    );
  }

  void advanceDriverStatus() {
    switch (state.phase) {
      case TripPhase.driverEnRouteToPatient:
        emit(state.copyWith(phase: TripPhase.arrivedAtPatient));
        break;
      case TripPhase.arrivedAtPatient:
        emit(state.copyWith(phase: TripPhase.patientPickedUp));
        break;
      case TripPhase.patientPickedUp:
        emit(state.copyWith(phase: TripPhase.arrivedAtHospital));
        break;
      case TripPhase.arrivedAtHospital:
        emit(state.copyWith(phase: TripPhase.completed));
        break;
      default:
        break;
    }
  }

  /// Mock ambulance position along route for patient map.
  LatLng ambulanceMarkerPosition() {
    const patient = LatLng(9.0107, 38.7613);
    const hospital = LatLng(9.0320, 38.7469);
    final t = switch (state.phase) {
      TripPhase.awaitingDriverAcceptance => 0.15,
      TripPhase.driverEnRouteToPatient => 0.35,
      TripPhase.arrivedAtPatient => 0.5,
      TripPhase.patientPickedUp => 0.72,
      TripPhase.arrivedAtHospital => 0.95,
      TripPhase.completed => 1.0,
      TripPhase.none => 0.0,
    };
    return LatLng(
      patient.latitude + (hospital.latitude - patient.latitude) * t,
      patient.longitude + (hospital.longitude - patient.longitude) * t,
    );
  }

  List<LatLng> routePolyline() {
    return const [
      LatLng(9.0107, 38.7613),
      LatLng(9.0180, 38.7550),
      LatLng(9.0250, 38.7505),
      LatLng(9.0320, 38.7469),
    ];
  }
}
