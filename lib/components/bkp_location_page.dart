import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // ValueNotifier avoids rebuilding the whole widget tree (including the
  // GoogleMap, which is expensive) just to toggle the FAB / myLocation flag.
  final ValueNotifier<bool> _locationGranted = ValueNotifier<bool>(false);

  static const CameraPosition _colombo = CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 14.4746,
  );

  // Guards against overlapping calls if the user taps the FAB repeatedly
  // before the previous request resolves.
  bool _isFetchingLocation = false;

  Future<void> _goToMyLocation() async {
    if (_isFetchingLocation) return;
    _isFetchingLocation = true;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      final controller = await _controller.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 20,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Unable to get location: $e');
    } finally {
      _isFetchingLocation = false;
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();

    if (!mounted) return;

    if (status.isGranted) {
      _locationGranted.value = true;

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      }
      return;
    }

    if (status.isPermanentlyDenied) {
      _locationGranted.value = false;
      await openAppSettings();
      return;
    }

    _locationGranted.value = false;
  }

  @override
  void initState() {
    super.initState();
    // Defer to after first frame so the map renders immediately instead of
    // waiting on the permission dialog round-trip.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
    });
  }

  @override
  void dispose() {
    _locationGranted.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: _locationGranted,
        // The builder only rebuilds this subtree (GoogleMap + FAB),
        // not the whole Scaffold, and GoogleMap itself is passed in
        // as `child` so it is NOT rebuilt when _locationGranted changes.
        builder: (context, granted, child) {
          return child!;
        },
        child: _MapWithLocationButton(
          controller: _controller,
          initialCameraPosition: _colombo,
          locationGranted: _locationGranted,
          onLocateMe: _goToMyLocation,
        ),
      ),
    );
  }
}

/// Split out so GoogleMap's expensive build/param diffing isn't retriggered
/// by unrelated state changes higher up the tree. myLocationEnabled and the
/// FAB visibility are read from the ValueListenableBuilder here, scoped
/// tightly to just what needs it.
class _MapWithLocationButton extends StatelessWidget {
  const _MapWithLocationButton({
    required this.controller,
    required this.initialCameraPosition,
    required this.locationGranted,
    required this.onLocateMe,
  });

  final Completer<GoogleMapController> controller;
  final CameraPosition initialCameraPosition;
  final ValueNotifier<bool> locationGranted;
  final VoidCallback onLocateMe;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: locationGranted,
      builder: (context, granted, _) {
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController c) {
                if (!controller.isCompleted) controller.complete(c);
              },
              markerType: GoogleMapMarkerType.marker,
              zoomControlsEnabled: false,
              myLocationEnabled: granted,
              myLocationButtonEnabled: false,
            ),
            if (granted)
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: onLocateMe,
                  child: const Icon(Icons.my_location),
                ),
              ),
          ],
        );
      },
    );
  }
}
