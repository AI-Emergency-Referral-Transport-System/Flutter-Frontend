part of 'hospital_ops_cubit.dart';

class HospitalResources extends Equatable {
  const HospitalResources({
    this.bedsAvailable = 24,
    this.icuAvailable = 4,
    this.oxygenUnitsAvailable = 12,
    this.roomsAvailable = 10,
    this.capacityTimeSlots = const [
      '08:00–12:00',
      '12:00–16:00',
      '16:00–20:00',
    ],
  });

  final int bedsAvailable;
  final int icuAvailable;
  final int oxygenUnitsAvailable;
  final int roomsAvailable;
  final List<String> capacityTimeSlots;

  HospitalResources copyWith({
    int? bedsAvailable,
    int? icuAvailable,
    int? oxygenUnitsAvailable,
    int? roomsAvailable,
    List<String>? capacityTimeSlots,
  }) {
    return HospitalResources(
      bedsAvailable: bedsAvailable ?? this.bedsAvailable,
      icuAvailable: icuAvailable ?? this.icuAvailable,
      oxygenUnitsAvailable:
          oxygenUnitsAvailable ?? this.oxygenUnitsAvailable,
      roomsAvailable: roomsAvailable ?? this.roomsAvailable,
      capacityTimeSlots: capacityTimeSlots ?? this.capacityTimeSlots,
    );
  }

  @override
  List<Object?> get props => [
    bedsAvailable,
    icuAvailable,
    oxygenUnitsAvailable,
    roomsAvailable,
    capacityTimeSlots,
  ];
}

class HospitalIncomingPatient extends Equatable {
  const HospitalIncomingPatient({
    required this.id,
    required this.hospitalId,
    required this.patientName,
    required this.summary,
    required this.tripPhase,
    required this.createdAt,
    this.reservationFinalized = false,
  });

  final String id;
  final String hospitalId;
  final String patientName;
  final String summary;
  final TripPhase tripPhase;
  final DateTime createdAt;
  /// Bed reservation is applied only after the hospital taps Accept.
  final bool reservationFinalized;

  HospitalIncomingPatient copyWith({
    TripPhase? tripPhase,
    bool? reservationFinalized,
  }) {
    return HospitalIncomingPatient(
      id: id,
      hospitalId: hospitalId,
      patientName: patientName,
      summary: summary,
      tripPhase: tripPhase ?? this.tripPhase,
      createdAt: createdAt,
      reservationFinalized: reservationFinalized ?? this.reservationFinalized,
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
    reservationFinalized,
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
