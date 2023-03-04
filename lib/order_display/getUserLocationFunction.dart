import 'dart:async';
import 'orders_display.dart';
import 'package:location/location.dart';

bool _serviceEnabled = false;
Location location = Location();
PermissionStatus _permissionGranted = PermissionStatus.denied;
LocationData? _locationData;
StreamSubscription<LocationData>? locationSubscription;

Future<dynamic> getLocation() async {
  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();
  return _locationData;
}