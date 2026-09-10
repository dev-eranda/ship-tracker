import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/vessel.dart';

/// Mock vessel data around a busy shipping lane (Singapore Strait area)
/// so markers appear naturally clustered — good for testing clustering
/// behavior before Phase 3 wires in real MarineTraffic data.
final List<Vessel> _mockVessels = [
  Vessel(
    mmsi: '563012345',
    imo: '9321483',
    name: 'PACIFIC VOYAGER',
    type: VesselType.cargo,
    latitude: 1.290,
    longitude: 103.850,
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
    latitude: 1.305,
    longitude: 103.870,
    speedKnots: 8.5,
    courseDegrees: 120,
    destination: 'JURONG PORT',
    lastReport: DateTime.now().subtract(const Duration(minutes: 1)),
  ),
  Vessel(
    mmsi: '563012347',
    name: 'ISLAND FERRY 3',
    type: VesselType.passenger,
    latitude: 1.265,
    longitude: 103.820,
    speedKnots: 18.0,
    courseDegrees: 200,
    destination: 'BATAM',
    lastReport: DateTime.now().subtract(const Duration(seconds: 45)),
  ),
  Vessel(
    mmsi: '563012348',
    imo: '9321485',
    name: 'MAERSK HORIZON',
    type: VesselType.cargo,
    latitude: 1.310,
    longitude: 103.830,
    speedKnots: 16.7,
    courseDegrees: 270,
    destination: 'PORT KLANG',
    lastReport: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  Vessel(
    mmsi: '563012349',
    name: 'BLUE MARLIN',
    type: VesselType.fishing,
    latitude: 1.278,
    longitude: 103.865,
    speedKnots: 5.1,
    courseDegrees: 90,
    lastReport: DateTime.now().subtract(const Duration(minutes: 12)),
  ),
  Vessel(
    mmsi: '563012350',
    imo: '9321486',
    name: 'GULF EXPLORER',
    type: VesselType.tanker,
    latitude: 1.298,
    longitude: 103.845,
    speedKnots: 11.3,
    courseDegrees: 30,
    destination: 'RAFFLES ANCHORAGE',
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
