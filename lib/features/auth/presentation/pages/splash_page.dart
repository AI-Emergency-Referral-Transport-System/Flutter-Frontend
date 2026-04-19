import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import 'onboarding_page.dart';
import 'role_selection_page.dart';
import '../../../../shared/widgets/app_shell.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AuthCubit>().hydrate();
      if (!mounted) return;
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      final auth = context.read<AuthCubit>().state;
      if (!auth.onboardingComplete) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const OnboardingPage()),
        );
        return;
      }
      if (!auth.isLoggedIn || auth.user == null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const RoleSelectionPage()),
        );
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => AppShell(role: auth.user!.role),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final top = Color.lerp(scheme.surfaceContainerLow, scheme.primaryContainer, 0.35)!;
    final bottom = scheme.surface;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [top, bottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, size: 72, color: Colors.red.shade700),
            const SizedBox(height: 16),
            Text(
              'Derash',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Emergency referral & transport'),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
