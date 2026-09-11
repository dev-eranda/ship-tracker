import 'package:flutter/material.dart';

import '../../../core/models/vessel.dart';

/// A single vessel row in the search results list, built as a Material 3
/// Card. Uses M3's `Card.filled` (tonal, low elevation) which reads better
/// in a dense scrollable list than the default elevated Card — elevation
/// shadows stack awkwardly when many cards are visible at once.
class VesselListTile extends StatelessWidget {
  final Vessel vessel;
  final VoidCallback onTap;

  const VesselListTile({super.key, required this.vessel, required this.onTap});

  Color _typeColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (vessel.type) {
      case VesselType.cargo:
        return scheme.primary;
      case VesselType.tanker:
        return const Color(0xFFB3261E);
      case VesselType.passenger:
        return const Color(0xFF2E7D32);
      case VesselType.fishing:
        return const Color(0xFFF9A825);
      case VesselType.pleasureCraft:
        return scheme.secondary;
      case VesselType.other:
        return scheme.outline;
    }
  }

  IconData get _typeIcon {
    switch (vessel.type) {
      case VesselType.cargo:
        return Icons.local_shipping_outlined;
      case VesselType.tanker:
        return Icons.propane_tank_outlined;
      case VesselType.passenger:
        return Icons.directions_boat_filled_outlined;
      case VesselType.fishing:
        return Icons.phishing_outlined;
      case VesselType.pleasureCraft:
        return Icons.sailing_outlined;
      case VesselType.other:
        return Icons.anchor_outlined;
    }
  }

  String get _lastReportLabel {
    final diff = DateTime.now().difference(vessel.lastReport);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _typeColor(context);

    return Card.filled(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.withValues(alpha: 0.15),
                child: Icon(_typeIcon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vessel.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${vessel.type.label} · MMSI ${vessel.mmsi}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.speed,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${vessel.speedKnots.toStringAsFixed(1)} kn',
                          style: theme.textTheme.labelSmall,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _lastReportLabel,
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: theme.colorScheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}
