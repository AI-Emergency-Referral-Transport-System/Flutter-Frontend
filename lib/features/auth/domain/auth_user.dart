import 'package:equatable/equatable.dart';

import 'user_role.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
    this.gender,
    this.licensePlate,
    this.vehicleType,
    this.hospitalName,
    this.hospitalAddress,
    this.registrationNumber,
    this.linkedHospitalId,
  });

  final String id;
  final UserRole role;
  final String name;
  final String email;
  final String phone;
  final String? gender;
  final String? licensePlate;
  final String? vehicleType;
  final String? hospitalName;
  final String? hospitalAddress;
  final String? registrationNumber;

  /// Matches [HospitalRecommendation.id] for routing incoming referrals.
  final String? linkedHospitalId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'role': role.storageValue,
    'name': name,
    'email': email,
    'phone': phone,
    'gender': gender,
    'license_plate': licensePlate,
    'vehicle_type': vehicleType,
    'hospital_name': hospitalName,
    'hospital_address': hospitalAddress,
    'registration_number': registrationNumber,
    'linked_hospital_id': linkedHospitalId,
  };

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] ?? '') as String,
      role: UserRoleX.fromStorage(json['role'] as String?) ?? UserRole.patient,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      gender: json['gender'] as String?,
      licensePlate: json['license_plate'] as String?,
      vehicleType: json['vehicle_type'] as String?,
      hospitalName: json['hospital_name'] as String?,
      hospitalAddress: json['hospital_address'] as String?,
      registrationNumber: json['registration_number'] as String?,
      linkedHospitalId: json['linked_hospital_id'] as String?,
    );
  }

  AuthUser copyWith({
    String? id,
    UserRole? role,
    String? name,
    String? email,
    String? phone,
    String? gender,
    String? licensePlate,
    String? vehicleType,
    String? hospitalName,
    String? hospitalAddress,
    String? registrationNumber,
    String? linkedHospitalId,
  }) {
    return AuthUser(
      id: id ?? this.id,
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      licensePlate: licensePlate ?? this.licensePlate,
      vehicleType: vehicleType ?? this.vehicleType,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      linkedHospitalId: linkedHospitalId ?? this.linkedHospitalId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    role,
    name,
    email,
    phone,
    gender,
    licensePlate,
    vehicleType,
    hospitalName,
    hospitalAddress,
    registrationNumber,
    linkedHospitalId,
  ];
}
