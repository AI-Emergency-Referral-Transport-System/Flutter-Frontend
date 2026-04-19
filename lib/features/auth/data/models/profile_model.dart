import '../../domain/entities/profile_entity.dart';
import 'user_model.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required UserModel user,
    required super.fullName,
    required super.emergencyContact,
    required super.bloodType,
    required super.location,
    required super.updatedAt,
  }) : super(user: user);

  /// JSON → Model (REQUIRED)
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: (json['id'] ?? '').toString(),
      user: UserModel.fromJson(
        (json['user'] ?? {}) as Map<String, dynamic>,
      ),
      fullName: (json['full_name'] ?? '').toString(),
      emergencyContact: (json['emergency_contact'] ?? '').toString(),
      bloodType: (json['blood_type'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
    );
  }

  /// Entity → Model
  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      user: UserModel.fromEntity(entity.user),
      fullName: entity.fullName,
      emergencyContact: entity.emergencyContact,
      bloodType: entity.bloodType,
      location: entity.location,
      updatedAt: entity.updatedAt,
    );
  }

  /// Safe access (no repeated casting)
  UserModel get userModel => user as UserModel;

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': userModel.toJson(),
      'full_name': fullName,
      'emergency_contact': emergencyContact,
      'blood_type': bloodType,
      'location': location,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}