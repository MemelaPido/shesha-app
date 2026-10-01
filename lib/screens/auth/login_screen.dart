import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cellphone = TextEditingController(text: '082 123 4567');
  final _password = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _cellphone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final success = await auth.login(cellphone: _cellphone.text.trim(), password: _password.text);
    if (success && mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.dashboard, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('SHESHA', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text('WELCOME BACK', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 12),
            const Text("Ready when the road isn't.", style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('Sign in to manage your cover and request help.', style: TextStyle(color: AppColors.muted)),
            const SizedBox(height: 28),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AppTextField(controller: _cellphone, label: 'Cell number', keyboardType: TextInputType.phone, validator: _required),
                  const SizedBox(height: 16),
                  AppTextField(controller: _password, label: 'Password', obscureText: true, validator: _required),
                  if (auth.error != null) ...[
                    const SizedBox(height: 12),
                    Text(auth.error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 22),
                  PrimaryButton(label: 'Sign in', loading: auth.isLoading, onPressed: _signIn),
                  const SizedBox(height: 12),
                  PrimaryButton(label: 'Create account', outlined: true, onPressed: () => Navigator.pushNamed(context, AppRoutes.register)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) => value == null || value.trim().isEmpty ? 'This field is required.' : null;
}
