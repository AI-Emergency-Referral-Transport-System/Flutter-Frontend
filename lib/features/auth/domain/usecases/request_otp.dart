import 'package:flutter_frontend/features/auth/domain/repositories/auth_repository.dart';

class RequestOtp {
  final AuthRepository repository;
  RequestOtp(this.repository);

  Future<String> call(String phoneNumber) {
    return repository.requestOtp(phoneNumber: phoneNumber);
  }
}