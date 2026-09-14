import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/vessel.dart';

/// Mock vessel data around a busy shipping lane (Singapore Strait area)
/// so markers appear naturally clustered — good for testing clustering
/// behavior before Phase 3 wires in real MarineTraffic data.
final List<Vessel> _mockVessels = [
  // ─────────────────────────────────────────────
  // Cluster 1 - West of Colombo
  // ─────────────────────────────────────────────
  Vessel(
    mmsi: '563012345',
    imo: '9321483',
    name: 'PACIFIC VOYAGER',
    type: VesselType.cargo,
    latitude: 6.920,
    longitude: 79.720,
    speedKnots: 14.2,
    courseDegrees: 45,
    destination: 'COLOMBO',
    lastReport: DateTime.now().subtract(const Duration(minutes: 3)),
  ),
  Vessel(
    mmsi: '563012346',
    imo: '9321484',
    name: 'NORDIC STAR',
    type: VesselType.tanker,
    latitude: 6.930,
    longitude: 79.730,
    speedKnots: 8.5,
    courseDegrees: 120,
    destination: 'COLOMBO PORT',
    lastReport: DateTime.now().subtract(const Duration(minutes: 1)),
  ),
  Vessel(
    mmsi: '563012347',
    name: 'ISLAND FERRY 3',
    type: VesselType.passenger,
    latitude: 6.910,
    longitude: 79.725,
    speedKnots: 18.0,
    courseDegrees: 200,
    destination: 'GALLE',
    lastReport: DateTime.now().subtract(const Duration(seconds: 45)),
  ),

  // ─────────────────────────────────────────────
  // Cluster 2 - South-West of Colombo
  // ─────────────────────────────────────────────
  Vessel(
    mmsi: '563012349',
    name: 'BLUE MARLIN',
    type: VesselType.fishing,
    latitude: 6.770,
    longitude: 79.715,
    speedKnots: 5.1,
    courseDegrees: 90,
    destination: 'BERUWALA',
    lastReport: DateTime.now().subtract(const Duration(minutes: 12)),
  ),

  // ─────────────────────────────────────────────
  // Cluster 3 - North-West of Colombo
  // ─────────────────────────────────────────────
  Vessel(
    mmsi: '563012353',
    imo: '9321488',
    name: 'EASTERN GLORY',
    type: VesselType.tanker,
    latitude: 7.040,
    longitude: 79.710,
    speedKnots: 10.8,
    courseDegrees: 260,
    destination: 'COLOMBO PORT',
    lastReport: DateTime.now().subtract(const Duration(minutes: 2)),
  ),

  // ─────────────────────────────────────────────
  // Isolated vessel - South of Colombo
  // ─────────────────────────────────────────────
  Vessel(
    mmsi: '563012354',
    imo: '9321489',
    name: 'SOUTHERN CROSS',
    type: VesselType.cargo,
    latitude: 6.550,
    longitude: 79.650,
    speedKnots: 15.6,
    courseDegrees: 320,
    destination: 'COLOMBO',
    lastReport: DateTime.now().subtract(const Duration(minutes: 6)),
  ),

  // ─────────────────────────────────────────────
  // Isolated vessel - North of Colombo
  // ─────────────────────────────────────────────
  Vessel(
    mmsi: '563012355',
    name: 'COASTAL RUNNER',
    type: VesselType.passenger,
    latitude: 7.180,
    longitude: 79.650,
    speedKnots: 19.2,
    courseDegrees: 40,
    destination: 'NEGOMBO',
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
