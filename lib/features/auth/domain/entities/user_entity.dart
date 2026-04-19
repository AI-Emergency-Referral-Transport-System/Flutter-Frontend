import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String phoneNumber;
  final String email;
  final String role;
  final bool isVerified;

  const UserEntity({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.isVerified,
  });

  @override
  List<Object?> get props => [id, phoneNumber, email, role, isVerified];
}