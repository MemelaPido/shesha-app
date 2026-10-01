import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../models/vehicle.dart';
import '../../providers/vehicle_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  String _make = 'Toyota';
  final _model = TextEditingController(text: 'Corolla Cross');
  final _year = TextEditingController(text: '2024');
  final _registration = TextEditingController(text: 'ND 123 456');
  final _colour = TextEditingController(text: 'White');

  @override
  void dispose() {
    _model.dispose();
    _year.dispose();
    _registration.dispose();
    _colour.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<VehicleProvider>().addVehicle(
          Vehicle(
            id: DateTime.now().millisecondsSinceEpoch,
            make: _make,
            model: _model.text.trim(),
            year: int.parse(_year.text),
            registration: _registration.text.trim().toUpperCase(),
            colour: _colour.text.trim(),
          ),
        );
    Navigator.pushReplacementNamed(context, AppRoutes.choosePlan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('2/3 · Add vehicle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text('Which car are we covering?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 20),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vehicle photo selection will be connected in a later sprint.')),
                ),
                child: Container(
                  height: 116,
                  decoration: BoxDecoration(
                    color: AppColors.soft,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.line, width: 2),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, size: 30, color: AppColors.primary),
                      SizedBox(height: 6),
                      Text('Add vehicle photo', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Optional', style: TextStyle(fontSize: 11, color: AppColors.muted)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _make,
                decoration: const InputDecoration(labelText: 'Make'),
                items: const ['Toyota', 'Volkswagen', 'Ford', 'Hyundai', 'Nissan']
                    .map((make) => DropdownMenuItem(value: make, child: Text(make)))
                    .toList(),
                onChanged: (value) => setState(() => _make = value ?? _make),
              ),
              const SizedBox(height: 16),
              AppTextField(controller: _model, label: 'Model', validator: _required),
              const SizedBox(height: 16),
              AppTextField(controller: _year, label: 'Year', keyboardType: TextInputType.number, validator: _validYear),
              const SizedBox(height: 16),
              AppTextField(controller: _registration, label: 'Registration', validator: _required),
              const SizedBox(height: 16),
              AppTextField(controller: _colour, label: 'Colour', validator: _required),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Save vehicle', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? value) => value == null || value.trim().isEmpty ? 'This field is required.' : null;

  String? _validYear(String? value) {
    final year = int.tryParse(value ?? '');
    final maximum = DateTime.now().year + 1;
    if (year == null || year < 1950 || year > maximum) return 'Enter a valid vehicle year.';
    return null;
  }
}
