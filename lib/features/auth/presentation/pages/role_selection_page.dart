import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/user_role.dart';
import '../cubit/auth_cubit.dart';
import 'login_page.dart';
import 'signup_driver_page.dart';
import 'signup_hospital_page.dart';
import 'signup_patient_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose your role')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "What's your role?",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          _RoleCard(
            color: AppColors.patientBlue,
            title: 'I am a Patient',
            subtitle: 'Find care, chat with AI, track ambulance',
            onTap: () {
              context.read<AuthCubit>().setPendingRole(UserRole.patient);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SignupPatientPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _RoleCard(
            color: AppColors.driverOrange,
            title: 'I am a Driver',
            subtitle: 'Accept trips and update status',
            onTap: () {
              context.read<AuthCubit>().setPendingRole(UserRole.driver);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SignupDriverPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _RoleCard(
            color: AppColors.hospitalGreen,
            title: 'I am a Hospital',
            subtitle: 'Prepare beds, ICU, and oxygen',
            onTap: () {
              context.read<AuthCubit>().setPendingRole(UserRole.hospital);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const SignupHospitalPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute<void>(builder: (_) => const LoginPage()));
            },
            child: const Text('Already have an account? Login'),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: color, radius: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
