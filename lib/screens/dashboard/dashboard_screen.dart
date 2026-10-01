import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/assistance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/membership_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_bottom_navigation.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final vehicle = context.watch<VehicleProvider>().primaryVehicle;
    final plan = context.watch<MembershipProvider>().selectedPlan;
    final activeRequest = context.watch<AssistanceProvider>().activeRequest;
    final firstName = user?.fullName.split(' ').first ?? 'Member';

    void openAssistance() => Navigator.pushNamed(
          context,
          activeRequest == null ? AppRoutes.requestAssistance : AppRoutes.tracking,
        );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('GOOD AFTERNOON', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text('Hi, $firstName', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              ]),
              CircleAvatar(radius: 25, backgroundColor: AppColors.primary, foregroundColor: Colors.white, child: Text(_initials(user?.fullName ?? 'Shesha Member'))),
            ]),
            const SizedBox(height: 22),
            Card(
              child: ListTile(
                onTap: () => Navigator.pushNamed(context, AppRoutes.membership),
                title: Text('${plan.name} plan', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('R${plan.monthlyPrice}/mo · Active'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            if (activeRequest != null) ...[
              const SizedBox(height: 12),
              Card(
                color: const Color(0xFFE8F6EF),
                child: ListTile(
                  onTap: openAssistance,
                  leading: const Icon(Icons.local_shipping, color: Colors.green),
                  title: const Text('Help is on the way', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${activeRequest.partnerName} · ${activeRequest.etaMinutes} min away'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ],
            const SizedBox(height: 28),
            const Center(child: Text('Need roadside assistance?')),
            const SizedBox(height: 14),
            Center(
              child: SizedBox.square(
                dimension: 154,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primary, shape: const CircleBorder(), side: const BorderSide(color: Color(0xFFFFE0E7), width: 9), elevation: 8),
                  onPressed: openAssistance,
                  child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('SOS', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                    Text('HELP NOW', style: TextStyle(fontSize: 9)),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(child: Text('Tap for immediate assistance', style: TextStyle(color: AppColors.muted, fontSize: 12))),
            const SizedBox(height: 28),
            const Text('Quick assistance', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _QuickAction(icon: Icons.local_gas_station, label: 'Fuel', onTap: openAssistance)),
              const SizedBox(width: 10),
              Expanded(child: _QuickAction(icon: Icons.tire_repair, label: 'Tyre', onTap: openAssistance)),
              const SizedBox(width: 10),
              Expanded(child: _QuickAction(icon: Icons.car_crash, label: 'Windscreen', onTap: openAssistance)),
            ]),
            const SizedBox(height: 20),
            Card(
              child: vehicle == null
                  ? ListTile(leading: const Icon(Icons.add, color: AppColors.primary), title: const Text('Add a vehicle'), onTap: () => Navigator.pushNamed(context, AppRoutes.addVehicle))
                  : ListTile(leading: const Icon(Icons.directions_car, color: AppColors.primary), title: Text(vehicle.displayName, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${vehicle.registration} · ${vehicle.colour}')),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 0),
    );
  }

  static String _initials(String name) => name.trim().split(RegExp(r'\s+')).take(2).map((part) => part.isEmpty ? '' : part[0].toUpperCase()).join();
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 82), padding: const EdgeInsets.symmetric(vertical: 12)),
      onPressed: onTap,
      child: Column(children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.ink)),
      ]),
    );
  }
}
