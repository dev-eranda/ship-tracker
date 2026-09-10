import 'package:flutter/material.dart';

import '../../../core/models/vessel.dart';
import '../../../core/theme/app_theme.dart';

/// A single vessel marker: a small rotated triangle/arrow pointing in the
/// vessel's course direction, colored by vessel type. This is intentionally
/// simple (not a full ship icon) because at map scale, dozens of these need
/// to stay legible and cheap to render.
class VesselMarker extends StatelessWidget {
  final Vessel vessel;
  final bool isSelected;
  final VoidCallback onTap;

  const VesselMarker({
    super.key,
    required this.vessel,
    required this.onTap,
    this.isSelected = false,
  });

  Color get _typeColor {
    switch (vessel.type) {
      case VesselType.cargo:
        return AppColors.oceanBlue;
      case VesselType.tanker:
        return const Color(0xFFB3261E); // red — hazardous cargo convention
      case VesselType.passenger:
        return const Color(0xFF2E7D32); // green
      case VesselType.fishing:
        return const Color(0xFFF9A825); // amber
      case VesselType.pleasureCraft:
        return AppColors.skyBlue;
      case VesselType.other:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: vessel.courseDegrees * (3.14159265 / 180),
        child: Container(
          width: isSelected ? 28 : 22,
          height: isSelected ? 28 : 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _typeColor,
            border: Border.all(
              color: Colors.white,
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(Icons.navigation, color: Colors.white, size: 14),
        ),
      ),
    );
  }
}
