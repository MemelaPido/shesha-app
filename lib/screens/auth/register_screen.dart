import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _idNumber = TextEditingController();
  final _cellphone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    for (final controller in [_name, _idNumber, _cellphone, _email, _password]) { controller.dispose(); }
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await context.read<AuthProvider>().register(
      fullName: _name.text.trim(), cellphone: _cellphone.text.trim(), email: _email.text.trim(), password: _password.text,
    );
    if (success && mounted) Navigator.pushReplacementNamed(context, AppRoutes.addVehicle);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('1/3 · Your details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      body: SafeArea(child: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(24), children: [
        const Text("Let's get you covered", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        const SizedBox(height: 24),
        AppTextField(controller: _name, label: 'Full name', hint: 'Kabelo Mokoena', validator: _required), const SizedBox(height: 16),
        AppTextField(controller: _idNumber, label: 'SA ID number', hint: '13-digit ID number', keyboardType: TextInputType.number, validator: _validateId), const SizedBox(height: 16),
        AppTextField(controller: _cellphone, label: 'Cell number', hint: '082 123 4567', keyboardType: TextInputType.phone, validator: _required), const SizedBox(height: 16),
        AppTextField(controller: _email, label: 'Email', hint: 'name@example.com', keyboardType: TextInputType.emailAddress, validator: _validateEmail), const SizedBox(height: 16),
        AppTextField(controller: _password, label: 'Create password', obscureText: true, validator: _validatePassword), const SizedBox(height: 24),
        PrimaryButton(label: 'Continue', loading: auth.isLoading, onPressed: _register),
      ]))),
    );
  }

  String? _required(String? value) => value == null || value.trim().isEmpty ? 'This field is required.' : null;
  String? _validateId(String? value) => value == null || !RegExp(r'^\d{13}$').hasMatch(value) ? 'Enter a valid 13-digit SA ID number.' : null;
  String? _validateEmail(String? value) => value == null || !value.contains('@') ? 'Enter a valid email address.' : null;
  String? _validatePassword(String? value) => value == null || value.length < 8 ? 'Use at least 8 characters.' : null;
}
