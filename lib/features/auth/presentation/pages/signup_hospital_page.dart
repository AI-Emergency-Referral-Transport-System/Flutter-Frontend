import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/auth_user.dart';
import '../../domain/otp_mode.dart';
import '../../domain/user_role.dart';
import '../cubit/auth_cubit.dart';
import 'otp_page.dart';

class SignupHospitalPage extends StatefulWidget {
  const SignupHospitalPage({super.key});

  @override
  State<SignupHospitalPage> createState() => _SignupHospitalPageState();
}

class _SignupHospitalPageState extends State<SignupHospitalPage> {
  final _hospitalName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _registration = TextEditingController();
  String _linkedId = 'h1';

  @override
  void dispose() {
    _hospitalName.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    _registration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hospital sign up')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _hospitalName,
            decoration: const InputDecoration(labelText: 'Hospital name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            decoration: const InputDecoration(labelText: 'Phone number'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _address,
            decoration: const InputDecoration(labelText: 'Hospital address'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _registration,
            decoration: const InputDecoration(
              labelText: 'Registration number',
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            // ignore: deprecated_member_use
            value: _linkedId,
            decoration: const InputDecoration(
              labelText: 'Facility ID for incoming referrals',
            ),
            items: const [
              DropdownMenuItem(value: 'h1', child: Text('h1 — St. Mary')),
              DropdownMenuItem(value: 'h2', child: Text('h2 — Unity Cardiac')),
              DropdownMenuItem(value: 'h3', child: Text('h3 — Hope Pediatric')),
              DropdownMenuItem(value: 'h4', child: Text('h4 — Metro Neuro')),
            ],
            onChanged: (v) => setState(() => _linkedId = v ?? _linkedId),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_hospitalName.text.isEmpty ||
                  _email.text.isEmpty ||
                  _phone.text.isEmpty ||
                  _address.text.isEmpty ||
                  _registration.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }
              final user = AuthUser(
                id: 'hosp-${DateTime.now().millisecondsSinceEpoch}',
                role: UserRole.hospital,
                name: _hospitalName.text.trim(),
                email: _email.text.trim(),
                phone: _phone.text.trim(),
                hospitalName: _hospitalName.text.trim(),
                hospitalAddress: _address.text.trim(),
                registrationNumber: _registration.text.trim(),
                linkedHospitalId: _linkedId,
              );
              context.read<AuthCubit>().submitSignup(user);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => OtpPage(
                    mode: OtpMode.signup,
                    recipient: _phone.text.trim(),
                    draftUser: user,
                  ),
                ),
              );
            },
            child: const Text('Continue to OTP'),
          ),
        ],
      ),
    );
  }
}
