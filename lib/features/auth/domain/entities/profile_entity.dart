import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class ProfileEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String fullName;
  final String emergencyContact;
  final String bloodType;
  final String location;
  final DateTime? updatedAt;

  const ProfileEntity({
    required this.id,
    required this.user,
    required this.fullName,
    required this.emergencyContact,
    required this.bloodType,
    required this.location,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, user, fullName, emergencyContact, bloodType, location, updatedAt];
}