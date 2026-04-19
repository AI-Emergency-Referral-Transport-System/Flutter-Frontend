import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import 'role_selection_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF8FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_hospital, size: 80, color: Colors.red.shade700),
            const SizedBox(height: 16),
            Text(
              'Derash',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Emergency referral and transport system',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await context.read<AuthCubit>().completeOnboarding();
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const RoleSelectionPage(),
                    ),
                  );
                },
                child: const Text('Get Started'),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'New users continue to role selection.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
