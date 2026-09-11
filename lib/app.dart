import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/map/presentation/map_screen.dart';

class VesselTrackerApp extends StatelessWidget {
  const VesselTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vessel Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/home',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MapScreen(),
      },
    );
  }
}
