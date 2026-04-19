part of 'hospital_ops_cubit.dart';

class HospitalResources extends Equatable {
  const HospitalResources({
    this.bedsAvailable = 24,
    this.icuAvailable = 4,
    this.oxygenUnitsAvailable = 12,
  });

  final int bedsAvailable;
  final int icuAvailable;
  final int oxygenUnitsAvailable;

  HospitalResources copyWith({
    int? bedsAvailable,
    int? icuAvailable,
    int? oxygenUnitsAvailable,
  }) {
    return HospitalResources(
      bedsAvailable: bedsAvailable ?? this.bedsAvailable,
      icuAvailable: icuAvailable ?? this.icuAvailable,
      oxygenUnitsAvailable:
          oxygenUnitsAvailable ?? this.oxygenUnitsAvailable,
    );
  }

  @override
  List<Object?> get props => [bedsAvailable, icuAvailable, oxygenUnitsAvailable];
}

class HospitalIncomingPatient extends Equatable {
  const HospitalIncomingPatient({
    required this.id,
    required this.hospitalId,
    required this.patientName,
    required this.summary,
    required this.tripPhase,
    required this.createdAt,
  });

  final String id;
  final String hospitalId;
  final String patientName;
  final String summary;
  final TripPhase tripPhase;
  final DateTime createdAt;

  HospitalIncomingPatient copyWith({TripPhase? tripPhase}) {
    return HospitalIncomingPatient(
      id: id,
      hospitalId: hospitalId,
      patientName: patientName,
      summary: summary,
      tripPhase: tripPhase ?? this.tripPhase,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    hospitalId,
    patientName,
    summary,
    tripPhase,
    createdAt,
  ];
}

class HospitalOpsState extends Equatable {
  const HospitalOpsState({
    this.resources = const HospitalResources(),
    this.incoming = const [],
  });

  final HospitalResources resources;
  final List<HospitalIncomingPatient> incoming;

  HospitalOpsState copyWith({
    HospitalResources? resources,
    List<HospitalIncomingPatient>? incoming,
  }) {
    return HospitalOpsState(
      resources: resources ?? this.resources,
      incoming: incoming ?? this.incoming,
    );
  }

  @override
  List<Object?> get props => [resources, incoming];
}
