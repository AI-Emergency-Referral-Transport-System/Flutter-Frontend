import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/domain/user_role.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/pages/role_selection_page.dart';
import '../../../auth/domain/auth_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _gender;
  late final TextEditingController _plate;
  late final TextEditingController _vehicle;
  late final TextEditingController _hospitalName;
  late final TextEditingController _hospitalAddress;
  late final TextEditingController _registration;
  String? _linkedHospitalId;

  @override
  void initState() {
    super.initState();
    final u = context.read<AuthCubit>().state.user;
    _name = TextEditingController(text: u?.name ?? '');
    _email = TextEditingController(text: u?.email ?? '');
    _phone = TextEditingController(text: u?.phone ?? '');
    _gender = TextEditingController(text: u?.gender ?? '');
    _plate = TextEditingController(text: u?.licensePlate ?? '');
    _vehicle = TextEditingController(text: u?.vehicleType ?? '');
    _hospitalName = TextEditingController(text: u?.hospitalName ?? '');
    _hospitalAddress = TextEditingController(text: u?.hospitalAddress ?? '');
    _registration = TextEditingController(text: u?.registrationNumber ?? '');
    _linkedHospitalId = u?.linkedHospitalId ?? 'h1';
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _gender.dispose();
    _plate.dispose();
    _vehicle.dispose();
    _hospitalName.dispose();
    _hospitalAddress.dispose();
    _registration.dispose();
    super.dispose();
  }

  Future<void> _save(AuthUser current) async {
    final updated = AuthUser(
      id: current.id,
      role: current.role,
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      gender: current.role == UserRole.patient ? _gender.text.trim() : null,
      licensePlate: current.role == UserRole.driver ? _plate.text.trim() : null,
      vehicleType: current.role == UserRole.driver ? _vehicle.text.trim() : null,
      hospitalName: current.role == UserRole.hospital
          ? _hospitalName.text.trim()
          : null,
      hospitalAddress: current.role == UserRole.hospital
          ? _hospitalAddress.text.trim()
          : null,
      registrationNumber: current.role == UserRole.hospital
          ? _registration.text.trim()
          : null,
      linkedHospitalId: current.role == UserRole.hospital
          ? _linkedHospitalId
          : null,
    );
    await context.read<AuthCubit>().updateProfile(updated);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile saved')));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    final user = auth.user;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not signed in')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Dark mode'),
                subtitle: const Text('Uses saved preference on all screens'),
                value: mode == ThemeMode.dark,
                onChanged: (v) {
                  context.read<ThemeCubit>().setThemeMode(
                    v ? ThemeMode.dark : ThemeMode.light,
                  );
                },
              );
            },
          ),
          const Divider(),
          CircleAvatar(
            radius: 36,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phone,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),
          if (user.role == UserRole.patient) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _gender,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
          ],
          if (user.role == UserRole.driver) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _plate,
              decoration: const InputDecoration(labelText: 'License plate'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _vehicle,
              decoration: const InputDecoration(labelText: 'Vehicle type'),
            ),
          ],
          if (user.role == UserRole.hospital) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _hospitalName,
              decoration: const InputDecoration(labelText: 'Hospital name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _hospitalAddress,
              decoration: const InputDecoration(labelText: 'Address'),
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
              value: _linkedHospitalId,
              items: const [
                DropdownMenuItem(value: 'h1', child: Text('h1 — St. Mary')),
                DropdownMenuItem(value: 'h2', child: Text('h2 — Unity')),
                DropdownMenuItem(value: 'h3', child: Text('h3 — Hope')),
                DropdownMenuItem(value: 'h4', child: Text('h4 — Metro')),
              ],
              onChanged: (v) => setState(() => _linkedHospitalId = v),
              decoration: const InputDecoration(
                labelText: 'Linked facility ID',
              ),
            ),
          ],
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _save(user),
            child: const Text('Save profile'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () async {
              await context.read<AuthCubit>().logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const RoleSelectionPage()),
                (route) => false,
              );
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}
