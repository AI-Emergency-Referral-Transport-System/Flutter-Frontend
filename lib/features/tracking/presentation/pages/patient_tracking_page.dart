import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../trip/presentation/cubit/trip_cubit.dart';

class PatientTrackingPage extends StatelessWidget {
  const PatientTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trip = context.watch<TripCubit>().state;
    final ambulancePos = context.read<TripCubit>().ambulanceMarkerPosition();
    final route = context.read<TripCubit>().routePolyline();

    return Scaffold(
      appBar: AppBar(title: const Text('Ambulance tracking')),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: ambulancePos,
                zoom: 13.2,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('ambulance'),
                  position: ambulancePos,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                  infoWindow: const InfoWindow(title: 'Ambulance'),
                ),
                Marker(
                  markerId: const MarkerId('you'),
                  position: route.first,
                  infoWindow: const InfoWindow(title: 'You'),
                ),
                Marker(
                  markerId: const MarkerId('hospital'),
                  position: route.last,
                  infoWindow: InfoWindow(
                    title: trip.activeHospital?.name ?? 'Hospital',
                  ),
                ),
              },
              polylines: {
                Polyline(
                  polylineId: const PolylineId('path'),
                  color: Colors.green,
                  width: 4,
                  points: route,
                ),
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ambulance crew',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Icon(Icons.badge)),
                  title: Text('Driver: Samuel T.'),
                  subtitle: Text('Ambulance • plate from dispatch'),
                ),
                Text(
                  'ETA ~ ${trip.phase == TripPhase.driverEnRouteToPatient ? 6 : 3} min',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
