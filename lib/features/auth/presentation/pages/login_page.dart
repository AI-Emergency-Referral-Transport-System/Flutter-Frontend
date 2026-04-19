import 'package:flutter/material.dart';

import '../../domain/otp_mode.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phone = TextEditingController();
  final _email = TextEditingController();
  bool _useEmail = false;

  @override
  void dispose() {
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Receive OTP on email'),
              value: _useEmail,
              onChanged: (v) => setState(() => _useEmail = v),
            ),
            TextField(
              controller: _useEmail ? _email : _phone,
              keyboardType: _useEmail
                  ? TextInputType.emailAddress
                  : TextInputType.phone,
              decoration: InputDecoration(
                labelText: _useEmail ? 'Email' : 'Phone number',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final value = (_useEmail ? _email.text : _phone.text).trim();
                  if (value.isEmpty) return;
                  final recipient = _useEmail ? _email.text.trim() : _phone.text.trim();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => OtpPage(
                        mode: OtpMode.login,
                        recipient: recipient,
                        useEmail: _useEmail,
                      ),
                    ),
                  );
                },
                child: const Text('Send OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
