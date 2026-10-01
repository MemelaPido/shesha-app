import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/assistance_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/membership_provider.dart';
import 'providers/vehicle_provider.dart';
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService())),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ChangeNotifierProvider(create: (_) => MembershipProvider()),
        ChangeNotifierProvider(create: (_) => AssistanceProvider()),
      ],
      child: const SheshaApp(),
    ),
  );
}
