import 'package:equatable/equatable.dart';
import 'profile_entity.dart';
import 'user_entity.dart';

class AuthSessionEntity extends Equatable {
  final String refresh;
  final String access;
  final UserEntity user;
  final ProfileEntity? profile;

  const AuthSessionEntity({
    required this.refresh,
    required this.access,
    required this.user,
    this.profile,
  });

  AuthSessionEntity copyWith({
    String? refresh,
    String? access,
    UserEntity? user,
    ProfileEntity? profile,
  }) {
    return AuthSessionEntity(
      refresh: refresh ?? this.refresh,
      access: access ?? this.access,
      user: user ?? this.user,
      profile: profile ?? this.profile,
    );
  }

  @override
  List<Object?> get props => [refresh, access, user, profile];
}