import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Flutter-level splash screen.
///
/// This is shown right after the native splash disappears. It's a real
/// widget/route (not just an image), so it's the right place to run
/// startup tasks: check auth state, load cached settings, warm up the
/// local DB, etc. Once those tasks finish, it navigates to the next
/// screen (Login or Home).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Run startup tasks in parallel with a minimum splash duration so the
    // logo doesn't just flash on screen if init is very fast.
    final minDuration = Future.delayed(const Duration(milliseconds: 1200));
    final initTasks = _runStartupTasks();

    await Future.wait([minDuration, initTasks]);

    if (!mounted) return;

    // TODO (Phase 2+): replace with real auth-state check.
    // For now this always routes to a placeholder Home screen.
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> _runStartupTasks() async {
    // Placeholder for real startup work you'll add later, e.g.:
    // - check stored auth token
    // - load user preferences from local storage
    // - fetch remote config
    // Keep this fast — splash should never feel like a loading screen.
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.oceanBlue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Logo(),
              const SizedBox(height: 24),
              const Text(
                'Vessel Tracker',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Live vessel tracking',
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.75),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo widget. Falls back to an icon if the image asset isn't present yet,
/// so the screen still runs before you've added real art.
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: 120,
      height: 120,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.directions_boat_filled_rounded,
            color: AppColors.white,
            size: 60,
          ),
        );
      },
    );
  }
}
