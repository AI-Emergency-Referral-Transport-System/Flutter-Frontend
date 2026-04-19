import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../trip/presentation/cubit/trip_cubit.dart';

part 'hospital_ops_state.dart';

class HospitalOpsCubit extends Cubit<HospitalOpsState> {
  HospitalOpsCubit() : super(const HospitalOpsState());

  void registerIncoming({
    required String hospitalId,
    required String patientName,
    required String summary,
    required TripPhase tripPhase,
    String? requestId,
  }) {
    final incoming = HospitalIncomingPatient(
      id: requestId ?? 'inc-${DateTime.now().millisecondsSinceEpoch}',
      hospitalId: hospitalId,
      patientName: patientName,
      summary: summary,
      tripPhase: tripPhase,
      createdAt: DateTime.now(),
    );
    emit(
      state.copyWith(incoming: [...state.incoming, incoming]),
    );
  }

  void syncTripPhase(String incomingId, TripPhase phase) {
    final list = state.incoming
        .map(
          (e) => e.id == incomingId ? e.copyWith(tripPhase: phase) : e,
        )
        .toList();
    emit(state.copyWith(incoming: list));
  }

  void updateResources({
    int? beds,
    int? icu,
    int? oxygen,
  }) {
    emit(
      state.copyWith(
        resources: state.resources.copyWith(
          bedsAvailable: beds ?? state.resources.bedsAvailable,
          icuAvailable: icu ?? state.resources.icuAvailable,
          oxygenUnitsAvailable: oxygen ?? state.resources.oxygenUnitsAvailable,
        ),
      ),
    );
  }

  void reserveBed() {
    if (state.resources.bedsAvailable > 0) {
      updateResources(beds: state.resources.bedsAvailable - 1);
    }
  }

  void reserveIcu() {
    if (state.resources.icuAvailable > 0) {
      updateResources(icu: state.resources.icuAvailable - 1);
    }
  }

  void reserveOxygen() {
    if (state.resources.oxygenUnitsAvailable > 0) {
      updateResources(oxygen: state.resources.oxygenUnitsAvailable - 1);
    }
  }
}
