import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_session_entity.dart';
import '../../domain/entities/profile_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSentSuccess extends AuthState {
  final String message;
  const OtpSentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthSessionLoaded extends AuthState {
  final AuthSessionEntity session;
  const AuthSessionLoaded(this.session);

  @override
  List<Object?> get props => [session];
}

class AuthProfileLoaded extends AuthState {
  final ProfileEntity profile;
  const AuthProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthLoggedOut extends AuthState {}