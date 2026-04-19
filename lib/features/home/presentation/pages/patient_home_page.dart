import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../ai_chat/presentation/cubit/ai_chat_cubit.dart';
import '../../../ai_chat/presentation/pages/ai_chat_page.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../hospitals/data/nearby_hospitals_repository.dart';
import '../../../ai_chat/domain/models/hospital_recommendation.dart';
import '../../../trip/presentation/cubit/trip_cubit.dart';
import '../../../tracking/presentation/pages/patient_tracking_page.dart';

String _initial(String? name) {
  if (name == null || name.isEmpty) return 'P';
  return name[0].toUpperCase();
}

class PatientHomePage extends StatefulWidget {
  const PatientHomePage({super.key});

  @override
  State<PatientHomePage> createState() => _PatientHomePageState();
}

class _PatientHomePageState extends State<PatientHomePage> {
  late Future<List<HospitalRecommendation>> _nearbyFuture;

  @override
  void initState() {
    super.initState();
    _reloadNearby();
  }

  void _reloadNearby() {
    _nearbyFuture = context.read<NearbyHospitalsRepository>().nearby();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state.user;
    final trip = context.watch<TripCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(_reloadNearby),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  child: Text(_initial(auth?.name)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${auth?.name ?? 'Patient'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const Text('Stay safe — help is one tap away.'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (trip.phase == TripPhase.awaitingDriverAcceptance)
              _Banner(
                color: Colors.orange.shade50,
                text:
                    'Request sent to ${trip.activeHospital?.name ?? 'hospital'}. Waiting for an ambulance driver.',
              ),
            if (trip.activeRequestId != null &&
                trip.phase != TripPhase.completed &&
                trip.phase != TripPhase.none)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PatientTrackingPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Live ambulance tracking'),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandRed,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  context.read<AiChatCubit>().sendMessage(
                    'EMERGENCY: I need immediate medical help.',
                    patientId: context.read<AuthCubit>().state.user?.id,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AiChatPage(showBackButton: true),
                    ),
                  );
                },
                child: const Text('Emergency request'),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AiChatPage(showBackButton: true),
                  ),
                );
              },
              icon: const Icon(Icons.smart_toy_outlined),
              label: const Text('Talk to AI assistant'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nearby hospitals',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                TextButton(
                  onPressed: () => setState(_reloadNearby),
                  child: const Text('Refresh'),
                ),
              ],
            ),
            FutureBuilder<List<HospitalRecommendation>>(
              future: _nearbyFuture,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final data = snap.data ?? const [];
                if (data.isEmpty) {
                  return const Text('No hospitals found.');
                }
                return Column(
                  children: data
                      .map(
                        (h) => Card(
                          child: ListTile(
                            title: Text(h.name),
                            subtitle: Text(
                              '${h.distanceKm?.toStringAsFixed(1) ?? '--'} km • '
                              '${h.rating?.toStringAsFixed(1) ?? '--'} ★',
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Recent activities',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const _ActivityTile(
              title: 'Profile updated',
              subtitle: 'Contact details saved',
              icon: Icons.person_outline,
            ),
            const _ActivityTile(
              title: 'Education tip',
              subtitle: 'When in doubt, call emergency services',
              icon: Icons.health_and_safety_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.surfaceTint,
          child: Icon(icon, color: AppColors.actionGreen),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
