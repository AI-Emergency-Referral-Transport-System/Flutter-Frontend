import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/app_input_field.dart';
import '../widgets/app_primary_button.dart';

class ProfileFormPage extends StatefulWidget {
  final String title;
  final String subtitle;

  const ProfileFormPage({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _bloodTypeController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emergencyContactController.dispose();
    _bloodTypeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved successfully')),
          );
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.subtitle),
                  const SizedBox(height: 24),
                  AppInputField(
                    controller: _fullNameController,
                    label: 'Full Name',
                  ),
                  const SizedBox(height: 14),
                  AppInputField(
                    controller: _emergencyContactController,
                    label: 'Emergency Contact',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),
                  AppInputField(
                    controller: _bloodTypeController,
                    label: 'Blood Type',
                  ),
                  const SizedBox(height: 14),
                  AppInputField(
                    controller: _locationController,
                    label: 'Location',
                  ),
                  const SizedBox(height: 22),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final loading = state is AuthLoading;
                      return AppPrimaryButton(
                        text: 'Save Profile',
                        loading: loading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  UpdateProfileEvent(
                                    fullName: _fullNameController.text.trim(),
                                    emergencyContact: _emergencyContactController.text.trim(),
                                    bloodType: _bloodTypeController.text.trim(),
                                    location: _locationController.text.trim(),
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