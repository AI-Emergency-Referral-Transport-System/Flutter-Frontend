import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class RequestOtpEvent extends AuthEvent {
  final String phoneNumber;
  const RequestOtpEvent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String code;
  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.code,
  });

  @override
  List<Object?> get props => [phoneNumber, code];
}

class LoadProfileEvent extends AuthEvent {}

class UpdateProfileEvent extends AuthEvent {
  final String fullName;
  final String emergencyContact;
  final String bloodType;
  final String location;

  const UpdateProfileEvent({
    required this.fullName,
    required this.emergencyContact,
    required this.bloodType,
    required this.location,
  });

  @override
  List<Object?> get props => [fullName, emergencyContact, bloodType, location];
}

class LogoutEvent extends AuthEvent {}