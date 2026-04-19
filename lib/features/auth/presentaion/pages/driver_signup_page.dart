import 'package:flutter/material.dart';
import 'profile_form_page.dart';

class DriverSignupPage extends StatelessWidget {
  const DriverSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileFormPage(
      title: 'Create Your Account',
      subtitle: 'As an Ambulance Driver',
    );
  }
}