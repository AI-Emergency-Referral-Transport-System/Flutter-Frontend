import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/request_provider.dart';
import '../../models/emergency_request_model.dart';

class EmergencyTracking extends StatefulWidget {
  const EmergencyTracking({super.key});

  @override
  State<EmergencyTracking> createState() => _EmergencyTrackingState();
}

class _EmergencyTrackingState extends State<EmergencyTracking> {
  LatLng _driverPos = LatLng(9.04, 38.75);
  final LatLng _patientPos = LatLng(9.03, 38.74);
  Timer? _simulationTimer;
  bool _otpVerified = false;
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Start simulation after OTP verified (logic handled below)
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      setState(() {
        double newLat = _driverPos.latitude - 0.0005;
        double newLng = _driverPos.longitude - 0.0005;
        
        if (newLat <= _patientPos.latitude) {
          _driverPos = _patientPos;
          timer.cancel();
        } else {
          _driverPos = LatLng(newLat, newLng);
        }
      });
    });
  }

  void _verifyOtp() {
    if (_otpController.text == "1234") {
      setState(() {
        _otpVerified = true;
      });
      _startSimulation();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified! Ambulance tracking started.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Use 1234 for demo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = Provider.of<RequestProvider>(context);
    final activeRequest = requestProvider.activeRequest;

    if (activeRequest == null) {
      return const Scaffold(body: Center(child: Text('No active request')));
    }

    return Scaffold(
      body: Stack(
        children: [
          // OpenStreetMap with flutter_map
          FlutterMap(
            options: MapOptions(
              initialCenter: _patientPos,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.derash.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _patientPos,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                  ),
                  if (_otpVerified)
                    Marker(
                      point: _driverPos,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.emergency, color: Color(0xFFC62828), size: 40),
                    ),
                ],
              ),
            ],
          ),
          // Back Button
          Positioned(
            top: 48,
            left: 24,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          // OTP / Status Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_otpVerified && activeRequest.status == RequestStatus.accepted)
                    _buildOtpSection()
                  else
                    _buildStatusSection(activeRequest),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpSection() {
    return Column(
      children: [
        Text(
          'Request Approved!',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the OTP sent to your phone to track the ambulance.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 4,
          style: const TextStyle(fontSize: 24, letterSpacing: 20, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            counterText: "",
            hintText: "0000",
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _verifyOtp,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC62828)),
          child: const Text('VERIFY & TRACK'),
        ),
      ],
    );
  }

  Widget _buildStatusSection(EmergencyRequestModel activeRequest) {
    String statusText = 'Waiting for Hospital...';
    if (activeRequest.status == RequestStatus.pending) {
      statusText = 'Requesting Assistance...';
    } else if (activeRequest.status == RequestStatus.accepted) {
      statusText = 'Hospital Approved!';
    } else if (activeRequest.status == RequestStatus.rejected) {
      statusText = 'Request Rejected';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFC62828).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                activeRequest.status.toString().split('.').last.toUpperCase(),
                style: GoogleFonts.poppins(
                  color: const Color(0xFFC62828),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            if (_otpVerified)
              Text(
                'Moving to you...',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.green),
              )
            else if (activeRequest.status == RequestStatus.pending)
              const CircularProgressIndicator(strokeWidth: 2),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          activeRequest.emergencyType ?? 'General Emergency',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          statusText,
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 24),
        if (_otpVerified) ...[
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFFF5F6FA),
                child: Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Abebe Bikila', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Ambulance - AB 123 CD', style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.phone, color: Color(0xFFC62828)),
                style: IconButton.styleFrom(backgroundColor: const Color(0xFFC62828).withValues(alpha: 0.1)),
              ),
            ],
          ),
        ] else if (activeRequest.status == RequestStatus.pending)
          const Center(child: Text('Waiting for hospital to accept...'))
        else if (activeRequest.status == RequestStatus.failed)
          const Text('Request failed. No drivers available.', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
