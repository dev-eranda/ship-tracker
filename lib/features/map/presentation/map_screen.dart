import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ship_tracker/features/map/providers/vessel_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  static const LatLng _initialCenter = LatLng(1.29, 103.85); // Singapore Strait

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 11,
              minZoom: 3,
              maxZoom: 18,
              onTap: (_, __) {
                ref.watch(selectedVesselProvider.notifier).state = null;
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ship_tracker',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
