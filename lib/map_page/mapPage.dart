import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:location/location.dart';



class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _serviceEnabled = false;
  Location location = new Location();
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  //LocationData _locationData = LocationData.fromMap({'latitude': 37.4219999, 'longitude': -122.0840575});
  LocationData? _locationData;
  StreamSubscription<LocationData>? locationSubscription;
  bool _isListenLocation = false;
  bool _isGetLocation = false;

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
  }

  void initState() {
    super.initState();
    getLocation();
    locationSubscription =
        Location().onLocationChanged.listen((LocationData _locationData) {
          setState(() {
            _locationData = _locationData;
          });
        });
  }

  void dispose() {
    if (locationSubscription != null) {
      locationSubscription?.cancel();
    }
    super.dispose();
  }

  List<Marker> allMarker = [];

  setMarker() {
    allMarker.add(Marker(
        width: 100.0,
        height: 100.0,
        point: latLng.LatLng(
            _locationData?.latitude ?? 0.0, _locationData?.longitude ?? 0.0),
        builder: (ctx) => Icon(
          Icons.my_location_rounded,
          color: Colors.blue,
        )));

    allMarker.add(new Marker(
        width: 200.0,
        height: 200.0,
        point: new latLng.LatLng(19.073836, 72.891126),
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.red,
        )));

    allMarker.add(new Marker(
        width: 200.0,
        height: 200.0,
        point: new latLng.LatLng(19.173736, 72.894128),
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.red,
        )));

    allMarker.add(new Marker(
        width: 200.0,
        height: 200.0,
        point: new latLng.LatLng(19.073736, 72.895126),
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.red,
        )));

    allMarker.add(new Marker(
        width: 200.0,
        height: 200.0,
        point: new latLng.LatLng(19.078996, 72.901331),
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.red,
        )));

    allMarker.add(new Marker(
        width: 200.0,
        height: 200.0,
        point: new latLng.LatLng(19.074556, 72.897129),
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.red,
        )));

    allMarker.add(new Marker(
        width: 200.0,
        height: 200.0,
        point: new latLng.LatLng(19.072556, 72.898129),
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.red,
        )));

    allMarker.add(new Marker(
        width: 200.0,
        height: 200.0,
        point: new latLng.LatLng(19.084903, 72.902328),
        builder: (ctx) => Icon(
          Icons.location_on,
          color: Colors.red,
        )));

    return allMarker;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _locationData != null
          ? new FlutterMap(
          options: new MapOptions(
              center: new latLng.LatLng(_locationData?.latitude ?? 0.0,
                  _locationData?.longitude ?? 0.0),
              zoom: 14.0),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                "https://api.mapbox.com/styles/v1/shrivatsa27/cldz201kl003h01pdp3to77ky/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2hyaXZhdHNhMjciLCJhIjoiY2xkejFkbWU3MHd2ZjNwcWptZ2kzNzFhNyJ9.ctks2LJ7nJvRGaC1YaR2fw",
                additionalOptions: {
                  'accessToken':
                  'pk.eyJ1Ijoic2hyaXZhdHNhMjciLCJhIjoiY2xkejFkbWU3MHd2ZjNwcWptZ2kzNzFhNyJ9.ctks2LJ7nJvRGaC1YaR2fw',
                  'id': 'mapbox.satellite'
                }),
            new MarkerLayerOptions(markers: setMarker())
          ])
          : Center(child: CircularProgressIndicator()),
    );
  }
}