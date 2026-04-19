import 'package:flutter_frontend/features/auth/domain/repositories/auth_repository.dart';
import '../entities/auth_session_entity.dart';

class VerifyOtp {
  final AuthRepository repository;
  VerifyOtp(this.repository);

  Future<AuthSessionEntity> call({
    required String phoneNumber,
    required String code,
  }) {
    return repository.verifyOtp(phoneNumber: phoneNumber, code: code);
  }
}