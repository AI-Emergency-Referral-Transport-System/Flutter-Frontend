import 'package:dio/dio.dart';

import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/auth_repository.dart';

import '../datasources/auth_local_ds.dart';
import '../datasources/auth_remote_ds.dart';

import '../models/auth_session_model.dart';
import '../models/user_model.dart';
import '../models/profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl({
    required this.remote,
    required this.local,
  });

  /// Handles expired access token automatically
  Future<T> _withAutoRefresh<T>(
    Future<T> Function(String accessToken) action,
  ) async {
    final session = await local.readSession();

    if (session == null) {
      throw Exception('No stored session. Please log in again.');
    }

    try {
      return await action(session.access);
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 401) {
        final newAccess = await refreshAccessToken();
        return await action(newAccess);
      }

      rethrow;
    }
  }

  @override
  Future<String> requestOtp({required String phoneNumber}) {
    return remote.requestOtp(phoneNumber: phoneNumber);
  }

  @override
  Future<AuthSessionEntity> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final session = await remote.verifyOtp(
      phoneNumber: phoneNumber,
      code: code,
    );

    await local.saveSession(session);

    return session;
  }

  @override
  Future<String> refreshAccessToken() async {
    final refresh = await local.getRefreshToken();

    if (refresh == null || refresh.isEmpty) {
      throw Exception('Refresh token missing. Please log in again.');
    }

    final newAccess = await remote.refreshToken(refresh: refresh);

    final session = await local.readSession();

    if (session != null) {
      await local.saveSession(
        AuthSessionModel(
          refresh: session.refresh,
          access: newAccess,

          // ✅ FIXED: convert Entity → Model
          user: UserModel.fromEntity(session.user),
          profile: session.profile == null
              ? null
              : ProfileModel.fromEntity(session.profile!),
        ),
      );
    }

    return newAccess;
  }

  @override
  Future<ProfileEntity> getProfile() async {
    final profile = await _withAutoRefresh(
      (access) => remote.getProfile(accessToken: access),
    );

    final session = await local.readSession();

    if (session != null) {
      await local.saveSession(
        AuthSessionModel(
          refresh: session.refresh,
          access: session.access,

          // ✅ FIXED
          user: UserModel.fromEntity(session.user),
          profile: ProfileModel.fromEntity(profile),
        ),
      );
    }

    return profile;
  }

  @override
  Future<ProfileEntity> updateProfile({
    required String fullName,
    required String emergencyContact,
    required String bloodType,
    required String location,
  }) async {
    final profile = await _withAutoRefresh((access) {
      return remote.updateProfile(
        accessToken: access,
        data: {
          'full_name': fullName,
          'emergency_contact': emergencyContact,
          'blood_type': bloodType,
          'location': location,
        },
      );
    });

    final session = await local.readSession();

    if (session != null) {
      await local.saveSession(
        AuthSessionModel(
          refresh: session.refresh,
          access: session.access,

          // ✅ FIXED
          user: UserModel.fromEntity(session.user),
          profile: ProfileModel.fromEntity(profile),
        ),
      );
    }

    return profile;
  }

  @override
  Future<AuthSessionEntity?> readSession() {
    return local.readSession();
  }

  @override
  Future<void> logout() {
    return local.clear();
  }
}