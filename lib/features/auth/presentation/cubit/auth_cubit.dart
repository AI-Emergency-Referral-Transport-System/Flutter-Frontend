import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import '../../domain/auth_user.dart';
import '../../domain/user_role.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> hydrate() async {
    final onboarding = _repository.onboardingComplete;
    final user = _repository.readUser();
    final loggedIn = _repository.isLoggedIn;
    emit(
      state.copyWith(
        status: AuthStatus.ready,
        onboardingComplete: onboarding,
        user: user,
        isLoggedIn: loggedIn,
        pendingRole: _repository.readLastRole(),
      ),
    );
  }

  Future<void> completeOnboarding() async {
    await _repository.setOnboardingComplete();
    emit(state.copyWith(onboardingComplete: true));
  }

  void setPendingRole(UserRole role) {
    emit(state.copyWith(pendingRole: role));
    _repository.setLastRole(role);
  }

  void clearPendingRole() {
    emit(state.copyWith(clearPendingRole: true));
  }

  Future<void> submitSignup(AuthUser draft) async {
    emit(state.copyWith(pendingOtpRecipient: draft.phone));
  }

  Future<void> verifyOtpAndLogin(AuthUser user) async {
    await _repository.saveSession(user);
    emit(
      state.copyWith(
        isLoggedIn: true,
        user: user,
        clearPendingOtp: true,
        pendingRole: user.role,
      ),
    );
  }

  Future<void> loginWithExistingUser(AuthUser user) async {
    await _repository.saveSession(user);
    emit(
      state.copyWith(
        isLoggedIn: true,
        user: user,
        clearPendingOtp: true,
        pendingRole: user.role,
      ),
    );
  }

  Future<void> logout() async {
    await _repository.clearSession();
    emit(
      state.copyWith(
        isLoggedIn: false,
        user: null,
      ),
    );
  }

  Future<void> updateProfile(AuthUser user) async {
    await _repository.saveSession(user);
    emit(state.copyWith(user: user));
  }
}
