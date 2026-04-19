import 'package:flutter_frontend/features/auth/domain/repositories/auth_repository.dart';
import '../entities/profile_entity.dart';

class UpdateProfile {
  final AuthRepository repository;
  UpdateProfile(this.repository);

  Future<ProfileEntity> call({
    required String fullName,
    required String emergencyContact,
    required String bloodType,
    required String location,
  }) {
    return repository.updateProfile(
      fullName: fullName,
      emergencyContact: emergencyContact,
      bloodType: bloodType,
      location: location,
    );
  }
}