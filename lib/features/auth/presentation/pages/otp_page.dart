import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_repository.dart';
import '../../domain/auth_user.dart';
import '../../domain/otp_mode.dart';
import '../cubit/auth_cubit.dart';
import '../../../../shared/widgets/app_shell.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({
    super.key,
    required this.mode,
    required this.recipient,
    this.useEmail = false,
    this.draftUser,
  });

  final OtpMode mode;
  final String recipient;
  final bool useEmail;
  final AuthUser? draftUser;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify(BuildContext context) async {
    // TODO(backend): replace with your verify-OTP API; remove this placeholder.
    if (_code.text.trim() != '1234') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid code.')),
      );
      return;
    }
    final auth = context.read<AuthCubit>();
    final repo = context.read<AuthRepository>();
    if (widget.mode == OtpMode.signup && widget.draftUser != null) {
      await auth.verifyOtpAndLogin(widget.draftUser!);
    } else {
      final existing = repo.readUser();
      final matchesPhone =
          existing != null && existing.phone == widget.recipient;
      final matchesEmail =
          existing != null && existing.email == widget.recipient;
      if (existing == null || !(matchesPhone || matchesEmail)) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No saved account for this device. Please sign up first.',
            ),
          ),
        );
        return;
      }
      await auth.loginWithExistingUser(existing);
    }
    if (!context.mounted) return;
    final user = context.read<AuthCubit>().state.user;
    if (user == null) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => AppShell(role: user.role)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 4-digit code sent to ${widget.recipient}',
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _code,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                labelText: 'OTP',
                counterText: '',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Until your backend sends real OTPs, use code 1234 for local testing.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _verify(context),
                child: const Text('Verify & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
