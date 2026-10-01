import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/assistance_provider.dart';
import '../../routes/app_routes.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<AssistanceProvider>().activeRequest;

    if (request == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Assistance tracking')),
        body: Center(
          child: FilledButton(
            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.requestAssistance),
            child: const Text('Create assistance request'),
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFE3E8E1), Color(0xFFF6F3EC)]),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton.filledTonal(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (_) => false),
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: AppColors.primary, size: 34),
                        const SizedBox(height: 12),
                        Container(width: 180, height: 5, color: AppColors.primary),
                        const SizedBox(height: 12),
                        const Icon(Icons.local_shipping, color: AppColors.ink, size: 34),
                        const SizedBox(height: 12),
                        Text(request.locationName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '${request.etaMinutes ?? 0} min\n${request.distanceKm?.toStringAsFixed(1) ?? '0.0'} km away',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: const Color(0xFFE8F6EF), borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      child: Text('PARTNER DISPATCHED', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Help is on the way', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('A response partner is heading to ${request.locationName}.', style: const TextStyle(color: AppColors.muted)),
                const SizedBox(height: 18),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(radius: 27, backgroundColor: AppColors.ink, foregroundColor: Colors.white, child: Text('SM')),
                  title: Text(request.partnerName ?? 'Response partner', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Response partner · ${request.partnerRating ?? 0} ★\n${request.partnerVehicle ?? ''}'),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: _ContactButton(icon: Icons.phone_outlined, label: 'Call')),
                    SizedBox(width: 10),
                    Expanded(child: _ContactButton(icon: Icons.message_outlined, label: 'Message')),
                    SizedBox(width: 10),
                    Expanded(child: _ContactButton(icon: Icons.share_outlined, label: 'Share')),
                  ],
                ),
                const SizedBox(height: 22),
                _TimelineItem(title: 'Request confirmed', time: _timeLabel(request.requestedAt), complete: true),
                _TimelineItem(title: 'Partner dispatched', time: _timeLabel(request.requestedAt.add(const Duration(minutes: 3))), complete: true),
                _TimelineItem(title: 'Partner arriving', time: _timeLabel(request.requestedAt.add(Duration(minutes: request.etaMinutes ?? 12))), complete: false),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    context.read<AssistanceProvider>().completeRequest();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.dashboard,
                      (_) => false,
                    );
                  },
                  child: const Text('Return to dashboard'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _timeLabel(DateTime value) {
    final hours = value.hour.toString().padLeft(2, '0');
    final minutes = value.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$label integration will be added later.'))),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 13)),
      child: Column(children: [Icon(icon, color: AppColors.primary), const SizedBox(height: 5), Text(label, style: const TextStyle(fontSize: 11))]),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.title, required this.time, required this.complete});
  final String title;
  final String time;
  final bool complete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(complete ? Icons.check_circle : Icons.radio_button_checked, color: complete ? Colors.green : AppColors.primary),
      title: Text(title),
      trailing: Text(time, style: const TextStyle(color: AppColors.muted)),
    );
  }
}
