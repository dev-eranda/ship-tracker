import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ship_tracker/core/theme/app_theme.dart';
import 'package:ship_tracker/features/map/providers/vessel_provider.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:ship_tracker/features/map/widgets/map_search_bar.dart';
import 'package:ship_tracker/features/map/widgets/vessel_filter_chips.dart';
import 'package:ship_tracker/features/map/widgets/vessel_marker.dart';
import 'package:ship_tracker/features/map/widgets/vessel_preview_sheet.dart';

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
    final vessels = ref.watch(filteredVesselsProvider);
    final selectedVessel = ref.watch(selectedVesselProvider);

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
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 45,
                  size: const Size(40, 40),
                  markers: vessels.map((vessel) {
                    return Marker(
                      point: LatLng(vessel.latitude, vessel.longitude),
                      width: 32,
                      height: 32,
                      child: VesselMarker(
                        vessel: vessel,
                        isSelected: selectedVessel?.mmsi == vessel.mmsi,
                        onTap: () {
                          ref.read(selectedVesselProvider.notifier).state =
                              vessel;
                        },
                      ),
                    );
                  }).toList(),
                  builder: (context, markers) {
                    // Cluster bubble shown when markers are close together.
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.oceanBlue,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // ── Top overlay: search bar + filter chips ──────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  MapSearchBar(
                    onChanged: (query) {
                      // TODO (later): wire real search/filter-by-name logic.
                    },
                    onMenuTap: () {
                      // TODO (later): open drawer / fleet screen.
                    },
                    onSettingsTap: () {
                      // TODO (later): navigate to settings screen.
                    },
                  ),
                  const SizedBox(height: 10),
                  const VesselFilterChips(),
                ],
              ),
            ),
          ),

          // ── Recenter button ─────────────────────────────
          Positioned(
            right: 16,
            bottom: selectedVessel != null
                ? MediaQuery.of(context).size.height * 0.32
                : MediaQuery.of(context).size.height * 0.03,
            child: FloatingActionButton(
              heroTag: 'recenter',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                _mapController.move(_initialCenter, 11);
              },
              child: const Icon(Icons.my_location, color: AppColors.oceanBlue),
            ),
          ),

          // ── Vessel preview bottom sheet ─────────────────
          if (selectedVessel != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                child: VesselPreviewSheet(
                  vessel: selectedVessel,
                  onClose: () {
                    ref.read(selectedVesselProvider.notifier).state = null;
                  },
                  onViewDetails: () {
                    // TODO (Phase 4): Navigator.pushNamed(context, '/vessel-detail', arguments: selectedVessel);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
