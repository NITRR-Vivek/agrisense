import 'package:agrisense/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../custom_elevated_button.dart';
import '../get_current_location_button.dart';

class GoogleMapWidget extends StatefulWidget {
  final LatLng initialPosition;

  const GoogleMapWidget({required this.initialPosition, super.key});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  LatLng? _pickedLocation;
  String _address = '';
  bool _locationPermissionGranted = true;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialPosition;
    _checkLocationPermission();
    _getAddressFromCoordinates(
      _pickedLocation!.latitude,
      _pickedLocation!.longitude,
    );
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationPermissionGranted = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationPermissionGranted = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationPermissionGranted = false;
      });
      return;
    }

    setState(() {
      _locationPermissionGranted = true;
    });
  }

  Future<void> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> result = await placemarkFromCoordinates(latitude, longitude);
      setState(() {
        _address = '${result[0].street}, ${result[0].locality}, ${result[0].administrativeArea}, ${result[0].postalCode}';
      });
    } catch (e) {
      setState(() {
        _address = 'Address not available!';
      });
    }
  }

  void _confirmLocation() {
    if (_pickedLocation != null) {
      Navigator.of(context).pop(_pickedLocation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a location!")),
      );
    }
  }

  void _goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      );
      setState(() {
        _pickedLocation = LatLng(position.latitude, position.longitude);
      });
      await _getAddressFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not get current location!"),
      ));
    }
  }

  void _enableLocationPermission() async {
    await Geolocator.requestPermission();
    _checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick location"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: widget.initialPosition,
              zoom: 19,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraMove: (CameraPosition position) {
              _pickedLocation = position.target;
            },
            onCameraIdle: () async {
              if (_pickedLocation != null) {
                await _getAddressFromCoordinates(
                  _pickedLocation!.latitude,
                  _pickedLocation!.longitude,
                );
              }
            },
          ),
          const Center(
            child: Icon(
              Icons.location_pin,
              size: 50,
              color: Colors.red,
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                      "Move map to set location.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                if (!_locationPermissionGranted)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Location required for better functionality of the app",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            CustomElevatedButton(
                              width: 100,
                              height: 40,
                              onPressed: _enableLocationPermission,
                              text: "Enable",
                              buttonTextStyle: const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (_pickedLocation != null)
            Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    CustomFloatingActionButton(
                      icon: Icons.my_location,
                      text: "Go to current Location",
                      borderColor: AppColors.primaryColor,
                      onPressed: _goToCurrentLocation,
                      width: 200,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _address,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    CustomElevatedButton(
                      text: "Confirm Location and proceed ►",
                      onPressed: _confirmLocation,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
