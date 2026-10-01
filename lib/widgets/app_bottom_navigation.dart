import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/assistance_provider.dart';
import '../routes/app_routes.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => _open(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          selectedIcon: Icon(Icons.add_circle),
          label: 'Help',
        ),
        NavigationDestination(
          icon: Icon(Icons.card_membership_outlined),
          selectedIcon: Icon(Icons.card_membership),
          label: 'Membership',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  void _open(BuildContext context, int index) {
    if (index == selectedIndex) return;

    late final String route;
    switch (index) {
      case 0:
        route = AppRoutes.dashboard;
        break;
      case 1:
        route = context.read<AssistanceProvider>().activeRequest == null
            ? AppRoutes.requestAssistance
            : AppRoutes.tracking;
        break;
      case 2:
        route = AppRoutes.membership;
        break;
      case 3:
        route = AppRoutes.profile;
        break;
      default:
        route = AppRoutes.dashboard;
    }

    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}
