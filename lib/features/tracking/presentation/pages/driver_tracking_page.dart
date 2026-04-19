import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../hospital_ops/presentation/cubit/hospital_ops_cubit.dart';
import '../../../notifications/domain/models/notification_item.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../../trip/presentation/cubit/trip_cubit.dart';

class DriverTrackingPage extends StatefulWidget {
  const DriverTrackingPage({super.key});

  @override
  State<DriverTrackingPage> createState() => _DriverTrackingPageState();
}

class _DriverTrackingPageState extends State<DriverTrackingPage> {
  @override
  Widget build(BuildContext context) {
    final trip = context.watch<TripCubit>().state;
    final points = context.read<TripCubit>().routePolyline();
    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.blueAccent,
      width: 5,
      points: points,
    );

    String actionLabel() {
      switch (trip.phase) {
        case TripPhase.driverEnRouteToPatient:
          return 'Arrived at patient location';
        case TripPhase.arrivedAtPatient:
          return 'Picked up patient';
        case TripPhase.patientPickedUp:
          return 'Arrived at hospital';
        case TripPhase.arrivedAtHospital:
          return 'Complete handoff';
        default:
          return 'Update status';
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Live navigation')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(9.018, 38.752),
                zoom: 13,
              ),
              polylines: {polyline},
              markers: {
                Marker(
                  markerId: const MarkerId('patient'),
                  position: points.first,
                  infoWindow: const InfoWindow(title: 'Patient'),
                ),
                Marker(
                  markerId: const MarkerId('hospital'),
                  position: points.last,
                  infoWindow: const InfoWindow(title: 'Hospital'),
                ),
              },
              myLocationEnabled: false,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip status: ${trip.phase.name}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                if (trip.phase != TripPhase.completed &&
                    trip.phase != TripPhase.none)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final tripCubit = context.read<TripCubit>();
                        final before = tripCubit.state.phase;
                        tripCubit.advanceDriverStatus();
                        final after = tripCubit.state;
                        final id = after.activeRequestId;
                        if (id != null) {
                          context.read<HospitalOpsCubit>().syncTripPhase(
                            id,
                            after.phase,
                          );
                        }
                        context.read<NotificationsCubit>().pushLocal(
                          NotificationItem(
                            id:
                                'trip-${DateTime.now().millisecondsSinceEpoch}',
                            title: 'Trip update',
                            body: 'Status moved from ${before.name} '
                                'to ${after.phase.name}',
                            createdAt: DateTime.now(),
                            channel: NotificationChannel.trip,
                          ),
                        );
                        if (after.phase == TripPhase.completed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Trip completed. Great job!'),
                            ),
                          );
                        }
                      },
                      child: Text(actionLabel()),
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
