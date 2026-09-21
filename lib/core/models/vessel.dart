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
  final VesselStatus status;
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
    required this.status,
    required this.lastReport,
  });

  factory Vessel.fromJson(Map<String, dynamic> json) => Vessel(
    mmsi: json['mmsi'] as String,
    imo: json['imo']?.toString(),
    name: (json['name'] ?? '') as String,
    type: _parseVesselType(json['type']),
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    speedKnots: (json['speedKnots'] as num).toDouble(),
    courseDegrees: (json['courseDegrees'] as num).toDouble(),
    destination: json['destination']?.toString(),
    status: _parseVesselStatus(json['status']),
    lastReport: DateTime.parse(json['lastReport'] as String),
  );

  static VesselType _parseVesselType(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'cargo':
        return VesselType.cargo;
      case 'tanker':
        return VesselType.tanker;
      case 'passenger':
        return VesselType.passenger;
      case 'fishing':
        return VesselType.fishing;
      case 'pleasurecraft':
        return VesselType.pleasureCraft;
      default:
        return VesselType.other;
    }
  }

  static VesselStatus _parseVesselStatus(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'docked':
        return VesselStatus.docked;
      default:
        return VesselStatus.active;
    }
  }
}

enum VesselStatus {
  active,
  docked;

  String get label {
    switch (this) {
      case VesselStatus.active:
        return 'Active';
      case VesselStatus.docked:
        return 'Docked';
    }
  }
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
