import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/auth_user.dart';
import '../../domain/otp_mode.dart';
import '../../domain/user_role.dart';
import '../cubit/auth_cubit.dart';
import 'otp_page.dart';

class SignupDriverPage extends StatefulWidget {
  const SignupDriverPage({super.key});

  @override
  State<SignupDriverPage> createState() => _SignupDriverPageState();
}

class _SignupDriverPageState extends State<SignupDriverPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _plate = TextEditingController();
  String _vehicle = 'Ambulance';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver sign up')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Full name'),
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
            controller: _plate,
            decoration: const InputDecoration(labelText: 'License plate'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            // ignore: deprecated_member_use
            value: _vehicle,
            items: const [
              DropdownMenuItem(value: 'Ambulance', child: Text('Ambulance')),
              DropdownMenuItem(value: 'Van', child: Text('Van')),
              DropdownMenuItem(value: 'SUV', child: Text('SUV')),
            ],
            onChanged: (v) => setState(() => _vehicle = v ?? _vehicle),
            decoration: const InputDecoration(labelText: 'Vehicle type'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_name.text.isEmpty ||
                  _email.text.isEmpty ||
                  _phone.text.isEmpty ||
                  _plate.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }
              final user = AuthUser(
                id: 'drv-${DateTime.now().millisecondsSinceEpoch}',
                role: UserRole.driver,
                name: _name.text.trim(),
                email: _email.text.trim(),
                phone: _phone.text.trim(),
                licensePlate: _plate.text.trim(),
                vehicleType: _vehicle,
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
