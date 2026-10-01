import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/assistance_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/primary_button.dart';

class RequestAssistanceScreen extends StatefulWidget {
  const RequestAssistanceScreen({super.key});

  @override
  State<RequestAssistanceScreen> createState() => _RequestAssistanceScreenState();
}

class _RequestAssistanceScreenState extends State<RequestAssistanceScreen> {
  static const _issues = <({String name, IconData icon})>[
    (name: 'Out of fuel', icon: Icons.local_gas_station),
    (name: 'Flat tyre', icon: Icons.tire_repair),
    (name: 'Blowout', icon: Icons.warning_amber_rounded),
    (name: 'Windscreen', icon: Icons.car_crash),
  ];

  int _selectedIssue = 0;
  int? _selectedVehicleId;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final vehicles = context.read<VehicleProvider>().vehicles;
    if (vehicles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add a vehicle first.')));
      return;
    }

    final vehicle = vehicles.firstWhere(
      (item) => item.id == (_selectedVehicleId ?? vehicles.first.id),
      orElse: () => vehicles.first,
    );

    await context.read<AssistanceProvider>().requestHelp(
      issueType: _issues[_selectedIssue].name,
      vehicle: vehicle,
      locationName: 'Durban North, KZN',
      latitude: -29.7821,
      longitude: 31.0478,
      note: _note.text.trim(),
    );

    if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.tracking);
  }

  @override
  Widget build(BuildContext context) {
    final vehicles = context.watch<VehicleProvider>().vehicles;
    final assistance = context.watch<AssistanceProvider>();
    _selectedVehicleId ??= vehicles.isEmpty ? null : vehicles.first.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request assistance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.phone_outlined))],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3D7),
                borderRadius: BorderRadius.circular(12),
                border: const Border(left: BorderSide(color: Colors.orange, width: 4)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Are you in a safe place?', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Call emergency services first if there is immediate danger.', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text('What happened?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _issues.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final selected = index == _selectedIssue;
                final issue = _issues[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () => setState(() => _selectedIssue = index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFFFF5F7) : Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.line, width: selected ? 2 : 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(issue.icon, color: AppColors.primary),
                        const SizedBox(height: 6),
                        Text(issue.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            if (vehicles.isEmpty)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                  title: const Text('No vehicle available'),
                  subtitle: const Text('Add a vehicle before requesting assistance.'),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.addVehicle),
                ),
              )
            else
              DropdownButtonFormField<int>(
                value: _selectedVehicleId,
                decoration: const InputDecoration(labelText: 'Vehicle'),
                items: vehicles
                    .map((vehicle) => DropdownMenuItem(
                          value: vehicle.id,
                          child: Text('${vehicle.displayName} · ${vehicle.registration}'),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedVehicleId = value),
              ),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: Icon(Icons.location_on, color: AppColors.primary),
                title: Text('Durban North, KZN', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Mock GPS location detected', style: TextStyle(color: Colors.green)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _note,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Note', hintText: 'Landmark or helpful details'),
            ),
            const SizedBox(height: 22),
            PrimaryButton(
              label: 'Request help now',
              loading: assistance.isSubmitting,
              onPressed: vehicles.isEmpty ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
