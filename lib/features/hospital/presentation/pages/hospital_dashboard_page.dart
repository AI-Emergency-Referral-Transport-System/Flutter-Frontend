import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../hospital_ops/presentation/cubit/hospital_ops_cubit.dart';
import 'hospital_patient_detail_page.dart';

class HospitalDashboardPage extends StatelessWidget {
  const HospitalDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state.user;
    final ops = context.watch<HospitalOpsCubit>().state;
    final linked = auth?.linkedHospitalId;

    final incoming = ops.incoming
        .where(
          (p) => linked == null || p.hospitalId == linked,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Hospital dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Resource availability',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ResourceTile(
                  label: 'Beds',
                  value: ops.resources.bedsAvailable,
                  icon: Icons.hotel,
                  onMinus: () => context.read<HospitalOpsCubit>().updateResources(
                    beds: (ops.resources.bedsAvailable - 1).clamp(0, 999),
                  ),
                  onPlus: () => context.read<HospitalOpsCubit>().updateResources(
                    beds: ops.resources.bedsAvailable + 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ResourceTile(
                  label: 'ICU',
                  value: ops.resources.icuAvailable,
                  icon: Icons.monitor_heart,
                  onMinus: () => context.read<HospitalOpsCubit>().updateResources(
                    icu: (ops.resources.icuAvailable - 1).clamp(0, 999),
                  ),
                  onPlus: () => context.read<HospitalOpsCubit>().updateResources(
                    icu: ops.resources.icuAvailable + 1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ResourceTile(
                  label: 'Oxygen',
                  value: ops.resources.oxygenUnitsAvailable,
                  icon: Icons.air,
                  onMinus: () => context.read<HospitalOpsCubit>().updateResources(
                    oxygen: (ops.resources.oxygenUnitsAvailable - 1).clamp(
                      0,
                      999,
                    ),
                  ),
                  onPlus: () => context.read<HospitalOpsCubit>().updateResources(
                    oxygen: ops.resources.oxygenUnitsAvailable + 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Incoming patients',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          if (incoming.isEmpty)
            const Text('No active referrals for your facility.'),
          ...incoming.map(
            (p) => Card(
              child: ListTile(
                title: Text(p.patientName),
                subtitle: Text(
                  '${p.summary}\nStatus: ${p.tripPhase.name}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => HospitalPatientDetailPage(patient: p),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  const _ResourceTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final int value;
  final IconData icon;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(icon, color: Colors.teal),
            Text(label, style: const TextStyle(fontSize: 12)),
            Text('$value', style: const TextStyle(fontWeight: FontWeight.w800)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: onMinus, icon: const Icon(Icons.remove)),
                IconButton(onPressed: onPlus, icon: const Icon(Icons.add)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
