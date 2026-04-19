import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_frontend/features/ai_chat/presentation/pages/ai_chat_page.dart';
import 'package:flutter_frontend/features/auth/domain/user_role.dart';
import 'package:flutter_frontend/features/driver/presentation/pages/driver_home_page.dart';
import 'package:flutter_frontend/features/home/presentation/pages/patient_home_page.dart';
import 'package:flutter_frontend/features/hospital/presentation/pages/hospital_dashboard_page.dart';
import 'package:flutter_frontend/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:flutter_frontend/features/notifications/presentation/pages/inbox_page.dart';
import 'package:flutter_frontend/features/profile/presentation/pages/profile_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.role});

  final UserRole role;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().loadNotifications();
    });
  }

  List<Widget> _pages() {
    switch (widget.role) {
      case UserRole.patient:
        return [
          const PatientHomePage(),
          const InboxPage(),
          const AiChatPage(),
          const ProfilePage(),
        ];
      case UserRole.driver:
        return [
          const DriverHomePage(),
          const InboxPage(),
          const ProfilePage(),
        ];
      case UserRole.hospital:
        return [
          const HospitalDashboardPage(),
          const InboxPage(),
          const ProfilePage(),
        ];
    }
  }

  List<NavigationDestination> _destinations() {
    switch (widget.role) {
      case UserRole.patient:
        return const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            label: 'AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ];
      case UserRole.driver:
        return const [
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ];
      case UserRole.hospital:
        return const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages();
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index.clamp(0, pages.length - 1),
        onDestinationSelected: (v) => setState(() => _index = v),
        destinations: _destinations(),
      ),
    );
  }
}
