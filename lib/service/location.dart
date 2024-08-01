import 'dart:math';
import 'package:agrisense/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

class LocationService {
  static Future<bool> _checkPermissions(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDialog(context);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _showPermissionDialog(context, permanent: true);
      return false;
    }

    return true;
  }

  static void _showPermissionDialog(BuildContext context, {bool permanent = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission'),
        content: Text(
          permanent
              ? 'Location permissions are permanently denied. Location permission is needed for getting the current weather update at your location. Please open the app settings and enable the location permission.'
              : 'Location permissions are required to get the current location. Location permission is needed for getting the current weather update at your location. Please enable them in the app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel',style: TextStyle(color: Colors.red),),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openAppSettings();
            },
            child: const Text('Open Settings',style: TextStyle(color: AppColors.primaryColor,),)
          ),
        ],
      ),
    );
  }

  static Future<Point<double>> getCoordinates({
    required BuildContext context,
    String? location,
    String languageCode = 'en-US',
  }) async {
    if (location == null) {
      bool hasPermissions = await _checkPermissions(context);
      if (!hasPermissions) {
        throw Exception('Location permissions are denied');
      }
      final result = await GeolocatorPlatform.instance.getCurrentPosition();
      return Point(result.latitude, result.longitude);
    } else {
      final result = await Nominatim.searchByName(
        query: location,
        limit: 1,
        language: languageCode,
      );
      return Point(result.first.lat, result.first.lon);
    }
  }

  static Future<Map<String, dynamic>?> fetchAddressFromCoordinates(
      double latitude, double longitude) async {
    final Place result;
    try {
      result = await Nominatim.reverseSearch(
        lat: latitude,
        lon: longitude,
      );
    } catch (exception) {
      debugPrint('Failed while fetching address: $exception');
      rethrow;
    }

    return result.address;
  }

  static Future<String?> fetchCityStateFromCoordinates(
      double latitude, double longitude ) async {
    final address = await fetchAddressFromCoordinates(latitude, longitude);
    if (address != null) {
      final cityState = '${address['city']}, ${address['state']}';
      return cityState;
    }
    return null;
  }
}
