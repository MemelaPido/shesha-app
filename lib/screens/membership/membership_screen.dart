import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/membership_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_bottom_navigation.dart';
import '../../widgets/primary_button.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final plan = context.watch<MembershipProvider>().selectedPlan;
    final fullName = user?.fullName ?? 'Shesha Member';
    final memberNumber = 'SH-${(user?.id ?? 284739).toString().padLeft(6, '0')}';
    final benefits = _benefitsFor(plan.name);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My membership', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF991031), Color(0xFFDD174C)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('SHESHA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      Text(plan.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Text(fullName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Member no. $memberNumber', style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 18),
                  const Divider(color: Colors.white30),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('● Active', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('Renews 30 Oct 2026', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Plan benefits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  for (var index = 0; index < benefits.length; index++) ...[
                    ListTile(
                      leading: Icon(benefits[index].$2, color: AppColors.primary),
                      title: Text(benefits[index].$1, style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: const Text('Covered', style: TextStyle(color: Colors.green, fontSize: 11)),
                    ),
                    if (index < benefits.length - 1) const Divider(height: 1),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MONTHLY PAYMENT', style: TextStyle(fontSize: 10, color: AppColors.muted, fontWeight: FontWeight.bold)),
                        SizedBox(height: 6),
                        Text('Next debit: 30 Oct 2026', style: TextStyle(color: AppColors.muted)),
                      ],
                    ),
                    Text('R${plan.monthlyPrice}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Upgrade my plan',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.choosePlan),
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Download membership card',
              outlined: true,
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membership-card download will be connected later.')),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 2),
    );
  }

  List<(String, IconData)> _benefitsFor(String planName) {
    switch (planName.toLowerCase()) {
      case 'basic':
        return const [
          ('Fuel assistance', Icons.local_gas_station),
          ('Four annual call-outs', Icons.support_agent),
        ];
      case 'premium':
        return const [
          ('Fuel assistance', Icons.local_gas_station),
          ('Tyre and wheel cover', Icons.tire_repair),
          ('Windscreen cover', Icons.car_crash),
        ];
      case 'family':
        return const [
          ('Fuel assistance', Icons.local_gas_station),
          ('Tyre and wheel cover', Icons.tire_repair),
          ('Windscreen cover', Icons.car_crash),
          ('Cover for up to 3 vehicles', Icons.directions_car),
        ];
      default:
        return const [
          ('Fuel assistance', Icons.local_gas_station),
          ('Tyre and wheel cover', Icons.tire_repair),
        ];
    }
  }
}
