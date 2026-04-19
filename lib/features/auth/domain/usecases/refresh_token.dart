import 'package:flutter_frontend/features/auth/domain/repositories/auth_repository.dart';

class RefreshToken {
  final AuthRepository repository;
  RefreshToken(this.repository);

  Future<String> call() => repository.refreshAccessToken();
}