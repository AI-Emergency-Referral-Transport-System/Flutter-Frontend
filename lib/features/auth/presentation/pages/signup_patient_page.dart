import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/auth_user.dart';
import '../../domain/otp_mode.dart';
import '../../domain/user_role.dart';
import '../cubit/auth_cubit.dart';
import 'otp_page.dart';

class SignupPatientPage extends StatefulWidget {
  const SignupPatientPage({super.key});

  @override
  State<SignupPatientPage> createState() => _SignupPatientPageState();
}

class _SignupPatientPageState extends State<SignupPatientPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  String _gender = 'Prefer not to say';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient sign up')),
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
          DropdownButtonFormField<String>(
            // ignore: deprecated_member_use
            value: _gender,
            items: const [
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
              DropdownMenuItem(
                value: 'Prefer not to say',
                child: Text('Prefer not to say'),
              ),
            ],
            onChanged: (v) => setState(() => _gender = v ?? _gender),
            decoration: const InputDecoration(labelText: 'Gender'),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_name.text.isEmpty ||
                  _email.text.isEmpty ||
                  _phone.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }
              final user = AuthUser(
                id: 'pat-${DateTime.now().millisecondsSinceEpoch}',
                role: UserRole.patient,
                name: _name.text.trim(),
                email: _email.text.trim(),
                phone: _phone.text.trim(),
                gender: _gender,
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
