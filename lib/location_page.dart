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

  bool _locationGranted = false;

  static const CameraPosition _colombo = CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 14.4746,
  );

  Future<void> _goToMyLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();

      // Check again after returning from settings.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final controller = await _controller.future;

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Unable to get location: $e');
    }
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();

    if (!mounted) return;

    if (status.isGranted) {
      // App permission is granted.
      setState(() {
        _locationGranted = true;
      });

      // Check whether the phone's Location/GPS is actually ON.
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      }

      return;
    }

    if (status.isPermanentlyDenied) {
      setState(() {
        _locationGranted = false;
      });

      // Take the user to Android app settings.
      await openAppSettings();
      return;
    }

    // Denied, restricted, or limited.
    setState(() {
      _locationGranted = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: _colombo,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markerType: GoogleMapMarkerType.marker,
        zoomControlsEnabled: false,
        myLocationEnabled: _locationGranted,
        myLocationButtonEnabled: false,
      ),

      floatingActionButton: _locationGranted
          ? FloatingActionButton(
              onPressed: _goToMyLocation,
              child: const Icon(Icons.my_location),
            )
          : null,
    );
  }
}

// static const CameraPosition _kLake = CameraPosition(
//   bearing: 192.8334901395799,
//   target: LatLng(37.43296265331129, -122.08832357078792),
//   tilt: 59.440717697143555,
//   zoom: 19.151926040649414,
// );

// Future<void> _goToTheLake() async {
//   final GoogleMapController controller = await _controller.future;
//   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
// }
