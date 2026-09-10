import 'package:flutter/material.dart';

class MapSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onMenuTap;
  final VoidCallback onSettingsTap;

  const MapSearchBar({
    super.key,
    required this.onChanged,
    required this.onMenuTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
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
            child: TextField(
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search vessels, MMSI, IMO...',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 14),
              ),
              style: const TextStyle(fontSize: 14),
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
