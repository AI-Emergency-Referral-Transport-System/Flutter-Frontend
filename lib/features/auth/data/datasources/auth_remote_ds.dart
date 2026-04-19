import 'package:dio/dio.dart';
import '../../auth_config.dart';
import '../models/auth_session_model.dart';
import '../models/profile_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio) {
    dio.options.baseUrl = AuthConfig.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 20);
    dio.options.receiveTimeout = const Duration(seconds: 20);
    dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<String> requestOtp({required String phoneNumber}) async {
    final res = await dio.post(
      AuthConfig.requestOtpPath,
      data: {'phone_number': phoneNumber},
    );
    return (res.data['detail'] ?? 'Verification code sent successfully.').toString();
  }

  Future<AuthSessionModel> verifyOtp({required String phoneNumber, required String code}) async {
    final res = await dio.post(
      AuthConfig.verifyOtpPath,
      data: {
        'phone_number': phoneNumber,
        'code': code,
      },
    );
    return AuthSessionModel.fromJson(Map<String, dynamic>.from(res.data as Map));
  }

  Future<String> refreshToken({required String refresh}) async {
    final res = await dio.post(
      AuthConfig.refreshTokenPath,
      data: {'refresh': refresh},
    );
    return (res.data['access'] ?? '').toString();
  }

  Future<ProfileModel> getProfile({required String accessToken}) async {
    final res = await dio.get(
      AuthConfig.profilePath,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return ProfileModel.fromJson(Map<String, dynamic>.from(res.data as Map));
  }

  Future<ProfileModel> updateProfile({
    required String accessToken,
    required Map<String, dynamic> data,
  }) async {
    final res = await dio.patch(
      AuthConfig.profilePath,
      data: data,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return ProfileModel.fromJson(Map<String, dynamic>.from(res.data as Map));
  }
}