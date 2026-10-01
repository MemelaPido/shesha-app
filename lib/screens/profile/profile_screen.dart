import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../models/assistance_request.dart';
import '../../providers/assistance_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/membership_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final plan = context.watch<MembershipProvider>().selectedPlan;
    final history = context.watch<AssistanceProvider>().history;
    final fullName = user?.fullName ?? 'Shesha Member';

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 44, 20, 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF93062C), Color(0xFFD61749)]),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 40),
                      Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Icon(Icons.settings_outlined, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    child: Text(_initials(fullName), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Text(fullName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${plan.name} member · Active', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 0, label: Text('History'), icon: Icon(Icons.history)),
                    ButtonSegment(value: 1, label: Text('Settings'), icon: Icon(Icons.settings_outlined)),
                  ],
                  selected: {_selectedTab},
                  showSelectedIcon: false,
                  onSelectionChanged: (selection) => setState(() => _selectedTab = selection.first),
                ),
                const SizedBox(height: 22),
                if (_selectedTab == 0) _HistoryPanel(history: history) else const _SettingsPanel(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 3),
    );
  }

  static String _initials(String name) => name
      .trim()
      .split(RegExp(r'\s+'))
      .take(2)
      .map((part) => part.isEmpty ? '' : part[0].toUpperCase())
      .join();
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({required this.history});

  final List<AssistanceRequest> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(color: AppColors.soft, borderRadius: BorderRadius.circular(16)),
        child: const Column(
          children: [
            Icon(Icons.history, size: 40, color: AppColors.muted),
            SizedBox(height: 10),
            Text('No assistance history yet.', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text('Completed assistance requests will appear here.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Assistance history', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (final request in history)
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFFFF0F4),
                foregroundColor: AppColors.primary,
                child: Icon(_issueIcon(request.issueType)),
              ),
              title: Text(request.issueType, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${request.locationName}\n${_dateLabel(request.requestedAt)} · Completed'),
              isThreeLine: true,
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('History PDF export will be connected later.')),
            ),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Export PDF'),
          ),
        ),
      ],
    );
  }

  static IconData _issueIcon(String issue) {
    final value = issue.toLowerCase();
    if (value.contains('fuel')) return Icons.local_gas_station;
    if (value.contains('tyre') || value.contains('blowout')) return Icons.tire_repair;
    return Icons.car_crash;
  }

  static String _dateLabel(DateTime value) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${value.day} ${months[value.month - 1]} ${value.year}';
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingTile(
          icon: Icons.card_membership,
          title: 'My membership',
          onTap: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.membership, (_) => false),
        ),
        _SettingTile(
          icon: Icons.person_outline,
          title: 'Personal details',
          onTap: () => _comingSoon(context, 'Personal details'),
        ),
        _SettingTile(
          icon: Icons.directions_car_outlined,
          title: 'My vehicles',
          onTap: () => Navigator.pushNamed(context, AppRoutes.addVehicle),
        ),
        _SettingTile(
          icon: Icons.payment_outlined,
          title: 'Payment method',
          onTap: () => _comingSoon(context, 'Payment method'),
        ),
        _SettingTile(
          icon: Icons.help_outline,
          title: 'Help and support',
          onTap: () => _comingSoon(context, 'Help and support'),
        ),
      ],
    );
  }

  static void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$feature will be connected later.')));
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.icon, required this.title, required this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
