import 'package:flutter/material.dart';
import 'profile_form_page.dart';

class PatientSignupPage extends StatelessWidget {
  const PatientSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileFormPage(
      title: 'Create Your Account',
      subtitle: 'As a patient',
    );
  }
}