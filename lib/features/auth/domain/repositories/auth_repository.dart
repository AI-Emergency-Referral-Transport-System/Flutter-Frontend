import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/profile_entity.dart';

abstract class AuthRepository {
  Future<String> requestOtp({required String phoneNumber});
  Future<AuthSessionEntity> verifyOtp({required String phoneNumber, required String code});
  Future<String> refreshAccessToken();
  Future<ProfileEntity> getProfile();
  Future<ProfileEntity> updateProfile({
    required String fullName,
    required String emergencyContact,
    required String bloodType,
    required String location,
  });
  Future<AuthSessionEntity?> readSession();
  Future<void> logout();
}