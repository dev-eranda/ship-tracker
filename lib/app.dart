import 'package:flutter/material.dart';
import 'package:ship_tracker/features/auth/presentation/login_screen.dart';
import 'package:ship_tracker/features/navigation/widgets/main_shell.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

class VesselTrackerApp extends StatelessWidget {
  const VesselTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vessel Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainShell(),
      },
    );
  }
}
