import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../hospital_ops/presentation/cubit/hospital_ops_cubit.dart';
import '../../../trip/presentation/cubit/trip_cubit.dart';

class HospitalPatientDetailPage extends StatelessWidget {
  const HospitalPatientDetailPage({super.key, required this.patient});

  final HospitalIncomingPatient patient;

  @override
  Widget build(BuildContext context) {
    final trip = context.watch<TripCubit>().state;
    final liveForRequest =
        trip.activeRequestId == patient.id ? trip.phase : null;

    return Scaffold(
      appBar: AppBar(title: Text(patient.patientName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'AI / patient summary',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(patient.summary),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Ambulance status'),
            subtitle: Text(
              liveForRequest == null
                  ? 'Awaiting driver acceptance'
                  : liveForRequest.name,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('ETA estimate'),
            subtitle: Text(
              switch (liveForRequest) {
                TripPhase.driverEnRouteToPatient => '~10 min to patient',
                TripPhase.arrivedAtPatient => 'At patient location',
                TripPhase.patientPickedUp => '~8 min to your ER',
                TripPhase.arrivedAtHospital => 'Arrived at hospital',
                TripPhase.completed => 'Trip completed',
                _ => 'Calculating…',
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<HospitalOpsCubit>().reserveIcu();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ICU bay reserved')),
                    );
                  },
                  child: const Text('Reserve ICU'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<HospitalOpsCubit>().reserveOxygen();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Oxygen unit staged')),
                    );
                  },
                  child: const Text('Stage oxygen'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
