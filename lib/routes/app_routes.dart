import 'package:flutter/material.dart';

import '../screens/assistance/request_assistance_screen.dart';
import '../screens/assistance/tracking_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/membership/choose_plan_screen.dart';
import '../screens/membership/membership_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/vehicle/add_vehicle_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const addVehicle = '/add-vehicle';
  static const choosePlan = '/choose-plan';
  static const dashboard = '/dashboard';
  static const requestAssistance = '/request-assistance';
  static const tracking = '/tracking';
  static const membership = '/membership';
  static const profile = '/profile';

  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    addVehicle: (_) => const AddVehicleScreen(),
    choosePlan: (_) => const ChoosePlanScreen(),
    dashboard: (_) => const DashboardScreen(),
    requestAssistance: (_) => const RequestAssistanceScreen(),
    tracking: (_) => const TrackingScreen(),
    membership: (_) => const MembershipScreen(),
    profile: (_) => const ProfileScreen(),
  };
}
