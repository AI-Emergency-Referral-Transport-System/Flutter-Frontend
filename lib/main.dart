import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:flutter_frontend/features/auth/presentaion/bloc/auth_event.dart';
import 'package:flutter_frontend/features/auth/presentaion/pages/role_selection_page.dart';

import 'features/auth/data/datasources/auth_local_ds.dart';
import 'features/auth/data/datasources/auth_remote_ds.dart';
import 'features/auth/data/repositories/auth_repo_impl.dart';

import 'features/auth/domain/repositories/auth_repository.dart';

import 'features/auth/domain/usecases/get_profile.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/domain/usecases/request_otp.dart';
import 'features/auth/domain/usecases/update_profile.dart';
import 'features/auth/domain/usecases/verify_otp.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppInitializer());
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    final localDataSource = AuthLocalDataSource();
    final remoteDataSource = AuthRemoteDataSource(dio);

    final AuthRepository authRepository = AuthRepositoryImpl(
      remote: remoteDataSource,
      local: localDataSource,
    );

    // Usecases (clean separation)
    final requestOtp = RequestOtp(authRepository);
    final verifyOtp = VerifyOtp(authRepository);
    final getProfile = GetProfile(authRepository);
    final updateProfile = UpdateProfile(authRepository);
    final logout = Logout(authRepository);

    return MyApp(
      requestOtp: requestOtp,
      verifyOtp: verifyOtp,
      getProfile: getProfile,
      updateProfile: updateProfile,
      logout: logout,
    );
  }
}

class MyApp extends StatelessWidget {
  final RequestOtp requestOtp;
  final VerifyOtp verifyOtp;
  final GetProfile getProfile;
  final UpdateProfile updateProfile;
  final Logout logout;

  const MyApp({
    super.key,
    required this.requestOtp,
    required this.verifyOtp,
    required this.getProfile,
    required this.updateProfile,
    required this.logout,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(
        requestOtp: requestOtp,
        verifyOtp: verifyOtp,
        getProfile: getProfile,
        updateProfile: updateProfile,
        logout: logout,
      )..add(AuthStarted()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RoleSelectionPage(),
      ),
    );
  }
}