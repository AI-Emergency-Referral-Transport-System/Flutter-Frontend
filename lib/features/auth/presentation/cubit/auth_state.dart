part of 'auth_cubit.dart';

enum AuthStatus { initial, ready }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.onboardingComplete = false,
    this.isLoggedIn = false,
    this.user,
    this.pendingRole,
    this.pendingOtpRecipient,
  });

  final AuthStatus status;
  final bool onboardingComplete;
  final bool isLoggedIn;
  final AuthUser? user;
  final UserRole? pendingRole;
  final String? pendingOtpRecipient;

  AuthState copyWith({
    AuthStatus? status,
    bool? onboardingComplete,
    bool? isLoggedIn,
    AuthUser? user,
    UserRole? pendingRole,
    String? pendingOtpRecipient,
    bool clearPendingRole = false,
    bool clearPendingOtp = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      pendingRole: clearPendingRole ? null : (pendingRole ?? this.pendingRole),
      pendingOtpRecipient: clearPendingOtp
          ? null
          : (pendingOtpRecipient ?? this.pendingOtpRecipient),
    );
  }

  @override
  List<Object?> get props => [
    status,
    onboardingComplete,
    isLoggedIn,
    user,
    pendingRole,
    pendingOtpRecipient,
  ];
}
