import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/request_otp.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/verify_otp.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RequestOtp requestOtp;
  final VerifyOtp verifyOtp;
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final Logout logout;

  AuthBloc({
    required this.requestOtp,
    required this.verifyOtp,
    required this.getProfile,
    required this.updateProfile,
    required this.logout,
  }) : super(AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<RequestOtpEvent>(_onRequestOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final profile = await getProfile();
      emit(AuthProfileLoaded(profile));
    } catch (_) {
      emit(AuthInitial());
    }
  }

  Future<void> _onRequestOtp(RequestOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final msg = await requestOtp(event.phoneNumber);
      emit(OtpSentSuccess(msg));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final session = await verifyOtp(
        phoneNumber: event.phoneNumber,
        code: event.code,
      );
      emit(AuthSessionLoaded(session));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLoadProfile(LoadProfileEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final profile = await getProfile();
      emit(AuthProfileLoaded(profile));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfileEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final profile = await updateProfile(
        fullName: event.fullName,
        emergencyContact: event.emergencyContact,
        bloodType: event.bloodType,
        location: event.location,
      );
      emit(AuthProfileLoaded(profile));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await logout();
    emit(AuthLoggedOut());
  }
}