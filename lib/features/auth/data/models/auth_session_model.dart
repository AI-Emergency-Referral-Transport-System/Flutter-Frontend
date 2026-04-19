import '../../domain/entities/auth_session_entity.dart';
import 'profile_model.dart';
import 'user_model.dart';

class AuthSessionModel extends AuthSessionEntity {
  const AuthSessionModel({
    required super.refresh,
    required super.access,
    required UserModel user,
    ProfileModel? profile,
  }) : super(user: user, profile: profile);

  /// Convenience getters (avoid repeated casting)
  UserModel get userModel => user as UserModel;
  ProfileModel? get profileModel => profile as ProfileModel?;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      refresh: (json['refresh'] ?? '').toString(),
      access: (json['access'] ?? '').toString(),
      user: UserModel.fromJson(
        (json['user'] ?? {}) as Map<String, dynamic>,
      ),
      profile: json['profile'] == null
          ? null
          : ProfileModel.fromJson(
              (json['profile'] ?? {}) as Map<String, dynamic>,
            ),
    );
  }

  /// Convert Model → JSON (safe)
  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
      'access': access,
      'user': userModel.toJson(),
      'profile': profileModel?.toJson(),
    };
  }

  /// Optional: Entity → Model (useful for repository)
  factory AuthSessionModel.fromEntity(AuthSessionEntity entity) {
    return AuthSessionModel(
      refresh: entity.refresh,
      access: entity.access,
      user: UserModel.fromEntity(entity.user),
      profile: entity.profile == null
          ? null
          : ProfileModel.fromEntity(entity.profile!),
    );
  }
}