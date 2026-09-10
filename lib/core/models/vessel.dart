/// Core vessel model used throughout the app.
///
/// Field names loosely mirror what MarineTraffic's API returns
/// (MMSI, IMO, SPEED, COURSE, etc.) so mapping the real API response
/// onto this model later (Phase 3) is straightforward.
class Vessel {
  final String mmsi;
  final String? imo;
  final String name;
  final VesselType type;
  final double latitude;
  final double longitude;
  final double speedKnots;
  final double courseDegrees; // direction of travel, for marker rotation
  final String? destination;
  final DateTime lastReport;

  const Vessel({
    required this.mmsi,
    this.imo,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.speedKnots,
    required this.courseDegrees,
    this.destination,
    required this.lastReport,
  });
}

enum VesselType {
  cargo,
  tanker,
  passenger,
  fishing,
  pleasureCraft,
  other;

  String get label {
    switch (this) {
      case VesselType.cargo:
        return 'Cargo';
      case VesselType.tanker:
        return 'Tanker';
      case VesselType.passenger:
        return 'Passenger';
      case VesselType.fishing:
        return 'Fishing';
      case VesselType.pleasureCraft:
        return 'Pleasure craft';
      case VesselType.other:
        return 'Other';
    }
  }
}
