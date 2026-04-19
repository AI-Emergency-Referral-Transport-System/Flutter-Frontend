import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/otp_input_field.dart';
import 'driver_signup_page.dart';
import 'hospital_signup_page.dart';
import 'patient_signup_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String role;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
    required this.role,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _goNext() {
    switch (widget.role.toLowerCase()) {
      case 'driver':
      case 'ambulance driver':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DriverSignupPage()),
        );
        break;
      case 'hospital':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HospitalSignupPage()),
        );
        break;
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatientSignupPage()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSessionLoaded) {
          _goNext();
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(leading: const BackButton()),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'Verify your phone',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Code sent to ${widget.phoneNumber}'),
                  const SizedBox(height: 28),
                  OtpInputField(controller: _otpController),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final loading = state is AuthLoading;
                      return AppPrimaryButton(
                        text: 'Verify OTP',
                        loading: loading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  VerifyOtpEvent(
                                    phoneNumber: widget.phoneNumber,
                                    code: _otpController.text.trim(),
                                  ),
                                );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}