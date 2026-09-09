import 'package:flutter/material.dart';
import 'package:ship_tracker/home_page.dart';
import 'package:ship_tracker/location_page.dart';
import 'package:ship_tracker/support_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.blue,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.white70),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.location_on, color: Colors.white70),
            icon: Icon(Icons.location_on_outlined),
            label: 'Explore',
          ),
          NavigationDestination(
            // icon: Badge(label: Text('2'), child: Icon(Icons.messenger_sharp)),
            // icon: Badge(child: Icon(Icons.info)),
            selectedIcon: Icon(Icons.info, color: Colors.white70),
            icon: Icon(Icons.info_outline),
            label: 'Support',
          ),
        ],
      ),
      body: <Widget>[
        // Home page
        HomePage(),

        // Notifications page
        LocationPage(),

        // Messages page
        SupportPage(),
      ][currentPageIndex],
    );
  }
}
