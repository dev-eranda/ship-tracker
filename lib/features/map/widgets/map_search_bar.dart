import 'package:flutter/material.dart';

class MapSearchBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onMenuTap;
  final VoidCallback onSettingsTap;

  const MapSearchBar({
    super.key,
    required this.onSearchTap,
    required this.onMenuTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, size: 22),
            onPressed: onMenuTap,
          ),
          Expanded(
            child: InkWell(
              onTap: onSearchTap,
              child: Row(
                children: [
                  Icon(Icons.search, size: 18, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Text(
                    'Search vessels, MMSI, IMO...',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, size: 20),
            onPressed: onSettingsTap,
          ),
        ],
      ),
    );
  }
}
