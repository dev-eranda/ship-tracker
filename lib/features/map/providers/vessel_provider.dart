import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/vessel.dart';

/// Mock vessel data around a busy shipping lane (Singapore Strait area)
/// so markers appear naturally clustered — good for testing clustering
/// behavior before Phase 3 wires in real MarineTraffic data.
final List<Vessel> _mockVessels = [
  // ─────────────────────────────────────────────
  // Cluster 1 - Singapore Strait / East
  // ─────────────────────────────────────────────
  Vessel(
    mmsi: '563012345',
    imo: '9321483',
    name: 'PACIFIC VOYAGER',
    type: VesselType.cargo,
    latitude: 1.245,
    longitude: 104.020,
    speedKnots: 14.2,
    courseDegrees: 45,
    destination: 'SINGAPORE',
    lastReport: DateTime.now().subtract(const Duration(minutes: 3)),
  ),
  Vessel(
    mmsi: '563012346',
    imo: '9321484',
    name: 'NORDIC STAR',
    type: VesselType.tanker,
    latitude: 1.250,
    longitude: 104.030,
    speedKnots: 8.5,
    courseDegrees: 120,
    destination: 'JURONG PORT',
    lastReport: DateTime.now().subtract(const Duration(minutes: 1)),
  ),
  Vessel(
    mmsi: '563012347',
    name: 'ISLAND FERRY 3',
    type: VesselType.passenger,
    latitude: 1.238,
    longitude: 104.015,
    speedKnots: 18.0,
    courseDegrees: 200,
    destination: 'BATAM',
    lastReport: DateTime.now().subtract(const Duration(seconds: 45)),
  ),

  // ─────────────────────────────────────────────
  // Cluster 2 - South of Singapore
  // ─────────────────────────────────────────────
  Vessel(
    mmsi: '563012348',
    imo: '9321485',
    name: 'MAERSK HORIZON',
    type: VesselType.cargo,
    latitude: 1.170,
    longitude: 103.900,
    speedKnots: 16.7,
    courseDegrees: 270,
    destination: 'PORT KLANG',
    lastReport: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Vessel(
    mmsi: '563012349',
    name: 'BLUE MARLIN',
    type: VesselType.fishing,
    latitude: 1.165,
    longitude: 103.910,
    speedKnots: 5.1,
    courseDegrees: 90,
    destination: 'BATAM',
    lastReport: DateTime.now().subtract(const Duration(minutes: 12)),
  ),
  Vessel(
    mmsi: '563012350',
    imo: '9321486',
    name: 'GULF EXPLORER',
    type: VesselType.tanker,
    latitude: 1.180,
    longitude: 103.895,
    speedKnots: 11.3,
    courseDegrees: 30,
    destination: 'RAFFLES ANCHORAGE',
    lastReport: DateTime.now().subtract(const Duration(minutes: 2)),
  ),

  // ─────────────────────────────────────────────
  // Cluster 3 - West / Singapore Strait
  // ─────────────────────────────────────────────
  Vessel(
    mmsi: '563012351',
    imo: '9321487',
    name: 'OCEAN TRADER',
    type: VesselType.cargo,
    latitude: 1.210,
    longitude: 103.650,
    speedKnots: 13.4,
    courseDegrees: 85,
    destination: 'SINGAPORE',
    lastReport: DateTime.now().subtract(const Duration(minutes: 4)),
  ),
  Vessel(
    mmsi: '563012352',
    name: 'SEA BREEZE',
    type: VesselType.fishing,
    latitude: 1.215,
    longitude: 103.660,
    speedKnots: 6.2,
    courseDegrees: 110,
    destination: 'BATAM',
    lastReport: DateTime.now().subtract(const Duration(minutes: 8)),
  ),
  Vessel(
    mmsi: '563012353',
    imo: '9321488',
    name: 'EASTERN GLORY',
    type: VesselType.tanker,
    latitude: 1.205,
    longitude: 103.645,
    speedKnots: 10.8,
    courseDegrees: 260,
    destination: 'PORT KLANG',
    lastReport: DateTime.now().subtract(const Duration(minutes: 2)),
  ),

  // ─────────────────────────────────────────────
  // Isolated vessel - useful for testing
  // ─────────────────────────────────────────────
  Vessel(
    mmsi: '563012354',
    imo: '9321489',
    name: 'SOUTHERN CROSS',
    type: VesselType.cargo,
    latitude: 1.050,
    longitude: 104.150,
    speedKnots: 15.6,
    courseDegrees: 320,
    destination: 'SINGAPORE',
    lastReport: DateTime.now().subtract(const Duration(minutes: 6)),
  ),

  Vessel(
    mmsi: '563012355',
    name: 'COASTAL RUNNER',
    type: VesselType.passenger,
    latitude: 1.080,
    longitude: 103.720,
    speedKnots: 19.2,
    courseDegrees: 40,
    destination: 'BATAM',
    lastReport: DateTime.now().subtract(const Duration(minutes: 2)),
  ),
];

/// Raw vessel list. In Phase 3 this becomes a FutureProvider/StreamProvider
/// that calls the MarineTraffic API (via your backend) instead of mock data.
final vesselListProvider = Provider<List<Vessel>>((ref) => _mockVessels);

/// Currently active type filters. Empty set = show all types.
final activeFiltersProvider = StateProvider<Set<VesselType>>((ref) => {});

/// The vessel the user has tapped on the map (drives the preview bottom sheet).
final selectedVesselProvider = StateProvider<Vessel?>((ref) => null);

/// Derived list: mock vessels after filters are applied.
final filteredVesselsProvider = Provider<List<Vessel>>((ref) {
  final vessels = ref.watch(vesselListProvider);
  final filters = ref.watch(activeFiltersProvider);
  if (filters.isEmpty) return vessels;
  return vessels.where((v) => filters.contains(v.type)).toList();
});
