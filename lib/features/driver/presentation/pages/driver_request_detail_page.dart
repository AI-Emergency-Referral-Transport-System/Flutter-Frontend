import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../notifications/domain/models/notification_item.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../trip/presentation/cubit/trip_cubit.dart';
import '../../../tracking/presentation/pages/driver_tracking_page.dart';

class DriverRequestDetailPage extends StatelessWidget {
  const DriverRequestDetailPage({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final trip = context.watch<TripCubit>().state;
    final matches = trip.openRequests.where((r) => r.id == requestId);
    final req = matches.isEmpty ? null : matches.first;
    if (req == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Request')),
        body: const Center(child: Text('Request no longer available.')),
      );
    }

    const chat = [
      ('Dispatch', 'Please acknowledge ETA within 2 minutes.'),
      ('Patient', 'We are at the pinned location, entrance B.'),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(req.patientName)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  req.summary,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text('Hospital: ${req.hospital.name}'),
                const SizedBox(height: 16),
                const Text(
                  'Chat',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...chat.map(
                  (c) => Align(
                    alignment: c.$1 == 'Patient'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: c.$1 == 'Patient'
                            ? const Color(0xFFEAF8FF)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.$1,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(c.$2),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<TripCubit>().driverDecline(req.id);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<TripCubit>().driverAccept(req.id);
                      context.read<NotificationsCubit>().pushLocal(
                        NotificationItem(
                          id: 'local-${DateTime.now().millisecondsSinceEpoch}',
                          title: 'Trip accepted',
                          body: 'You are en route to ${req.patientName}',
                          createdAt: DateTime.now(),
                          channel: NotificationChannel.trip,
                        ),
                      );
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const DriverTrackingPage(),
                        ),
                      );
                    },
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
