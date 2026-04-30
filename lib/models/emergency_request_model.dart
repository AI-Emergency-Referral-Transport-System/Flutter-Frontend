import 'package:latlong2/latlong.dart';

enum RequestStatus { pending, accepted, rejected, failed, completed }

class EmergencyRequestModel {
  final String id;
  final String patientId;
  final LatLng patientLocation;
  final String? emergencyType;
  final RequestStatus status;
  final String? assignedHospitalId;
  final String? assignedDriverId;
  final List<String> rejectedByHospitalIds;
  final DateTime createdAt;

  EmergencyRequestModel({
    required this.id,
    required this.patientId,
    required this.patientLocation,
    this.emergencyType,
    required this.status,
    this.assignedHospitalId,
    this.assignedDriverId,
    this.rejectedByHospitalIds = const [],
    required this.createdAt,
  });

  factory EmergencyRequestModel.fromJson(Map<String, dynamic> json) {
    return EmergencyRequestModel(
      id: json['id'],
      patientId: json['patient_id'],
      patientLocation: LatLng(json['latitude'], json['longitude']),
      emergencyType: json['emergency_type'],
      status: RequestStatus.values.firstWhere((e) => e.toString().split('.').last == json['status']),
      assignedHospitalId: json['assigned_hospital_id'],
      assignedDriverId: json['assigned_driver_id'],
      rejectedByHospitalIds: List<String>.from(json['rejected_by_hospitals'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'latitude': patientLocation.latitude,
      'longitude': patientLocation.longitude,
      'emergency_type': emergencyType,
      'status': status.toString().split('.').last,
      'assigned_hospital_id': assignedHospitalId,
      'assigned_driver_id': assignedDriverId,
      'rejected_by_hospitals': rejectedByHospitalIds,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
