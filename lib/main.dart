import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/ai_chat/data/ai_chat_repository.dart';
import 'features/ai_chat/presentation/cubit/ai_chat_cubit.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/hospital_ops/presentation/cubit/hospital_ops_cubit.dart';
import 'features/hospitals/data/nearby_hospitals_repository.dart';
import 'features/notifications/data/notification_repository.dart';
import 'features/notifications/presentation/cubit/notifications_cubit.dart';
import 'features/trip/presentation/cubit/trip_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(DerashApp(prefs: prefs));
}

class DerashApp extends StatelessWidget {
  const DerashApp({super.key, required this.prefs});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final authRepository = AuthRepository(prefs);
    final notificationRepository = NotificationRepository(apiClient.dio);
    final aiChatRepository = AiChatRepository(apiClient.dio);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: NearbyHospitalsRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ThemeCubit(prefs)..load(),
          ),
          BlocProvider(create: (_) => AuthCubit(authRepository)),
          BlocProvider(create: (_) => TripCubit()),
          BlocProvider(create: (_) => HospitalOpsCubit()),
          BlocProvider(
            create: (_) => NotificationsCubit(notificationRepository),
          ),
          BlocProvider(create: (_) => AiChatCubit(aiChatRepository)),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Derash',
              themeMode: themeMode,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              home: const SplashPage(),
            );
          },
        ),
      ),
    );
  }
}
