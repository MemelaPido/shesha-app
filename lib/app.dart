import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';

class SheshaApp extends StatelessWidget {
  const SheshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shesha',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
