import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ship_tracker/features/auth/provider/auth_provider.dart';
import 'package:ship_tracker/features/dashboard/presentation/dashboard_screen.dart';
import 'package:ship_tracker/features/dashboard/provider/nav_provider.dart';
import 'package:ship_tracker/features/map/presentation/map_screen.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider);
    final currentIndex = ref.watch(navIndexProvider);

    final tabs = <_TabItem>[
      _TabItem(
        label: 'Map',
        icon: Icons.map_outlined,
        activeIcon: Icons.map,
        screen: MapScreen(),
      ),
      if (isAdmin)
        _TabItem(
          label: 'Admin',
          icon: Icons.admin_panel_settings_outlined,
          activeIcon: Icons.admin_panel_settings,
          screen: const DashboardScreen(),
        ),
    ];

    final safeIndex = currentIndex < tabs.length ? currentIndex : 0;

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: tabs.map((t) => t.screen).toList(),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (i) =>
            ref.read(navIndexProvider.notifier).state = i,
        destinations: tabs
            .map(
              (t) => NavigationDestination(
                icon: Icon(t.icon),
                selectedIcon: Icon(t.activeIcon),
                label: t.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Widget screen;

  _TabItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.screen,
  });
}
