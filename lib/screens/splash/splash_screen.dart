import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openNextScreen());
  }

  Future<void> _openNextScreen() async {
    final authenticated = await context.read<AuthProvider>().restoreSession();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      authenticated ? AppRoutes.dashboard : AppRoutes.login,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(28, 56, 28, 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [AppColors.primaryLight, AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: const SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Center(child: _Logo()),
              Spacer(),
              Text(
                AppStrings.greeting,
                style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800, height: 1.1),
              ),
              SizedBox(height: 10),
              Text('Fast help. Fair price. Every month.', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 28),
              Center(child: CircularProgressIndicator(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Text('S', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900)),
        ),
        const SizedBox(height: 10),
        const Text(AppStrings.appName, style: TextStyle(color: Colors.white, fontSize: 28, letterSpacing: 3, fontWeight: FontWeight.bold)),
        const Text(AppStrings.tagline, style: TextStyle(color: Colors.white, fontSize: 10, letterSpacing: 2)),
      ],
    );
  }
}
