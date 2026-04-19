import 'package:flutter_frontend/features/auth/domain/repositories/auth_repository.dart';
import '../entities/profile_entity.dart';

class GetProfile {
  final AuthRepository repository;
  GetProfile(this.repository);

  Future<ProfileEntity> call() => repository.getProfile();
}