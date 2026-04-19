import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../trip/presentation/cubit/trip_cubit.dart';
import 'driver_request_detail_page.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final trip = context.watch<TripCubit>().state;
    return Scaffold(
      appBar: AppBar(title: const Text('Incoming requests')),
      body: trip.openRequests.isEmpty
          ? const Center(child: Text('No incoming requests right now.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: trip.openRequests.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final req = trip.openRequests[index];
                return Card(
                  child: ListTile(
                    title: Text(req.patientName),
                    subtitle: Text(
                      '${req.hospital.name} • ${req.summary}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              DriverRequestDetailPage(requestId: req.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
