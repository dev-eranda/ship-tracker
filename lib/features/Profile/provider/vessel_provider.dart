import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ship_tracker/core/models/vessel.dart';

final assignedVesselsProvider = FutureProvider((ref) async {
  await Future.delayed(const Duration(milliseconds: 3000));

  return [
    Vessel(
      mmsi: '563012354',
      imo: '9321489',
      name: 'Southern Cross',
      type: VesselType.cargo,
      latitude: 6.550,
      longitude: 79.650,
      speedKnots: 15.6,
      courseDegrees: 320,
      destination: 'COLOMBO',
      status: VesselStatus.active,
      lastReport: DateTime.now().subtract(const Duration(minutes: 6)),
    ),
    Vessel(
      mmsi: '563012355',
      imo: '',
      name: 'Coastal Runner',
      type: VesselType.passenger,
      latitude: 7.180,
      longitude: 79.650,
      speedKnots: 19.2,
      courseDegrees: 40,
      destination: 'NEGOMBO',
      status: VesselStatus.docked,
      lastReport: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];
});
