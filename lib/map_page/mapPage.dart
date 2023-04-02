import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:location/location.dart';
import '../order_display/orderDataList.dart';

final db = FirebaseFirestore.instance;
var orderData = OrderDataList();

void GetDataFromDatabaseMap() async {
  await db.collection("sellerOrder").get().then((event) {
    orderData.orderDataList = event.docs;
    print(orderData.orderDataList);
  });
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    GetDataFromDatabaseMap();
    super.initState();
    print("data aa raha hai");
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _locationData != null
          ? FlutterMap(
              options: MapOptions(
                  center: latLng.LatLng(_locationData?.latitude ?? 0.0,
                      _locationData?.longitude ?? 0.0),
                  zoom: 14.0,
                  rotationWinGestures: MultiFingerGesture.none),
              layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/shrivatsa27/cldz201kl003h01pdp3to77ky/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2hyaXZhdHNhMjciLCJhIjoiY2xkejFkbWU3MHd2ZjNwcWptZ2kzNzFhNyJ9.ctks2LJ7nJvRGaC1YaR2fw",
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1Ijoic2hyaXZhdHNhMjciLCJhIjoiY2xkejFkbWU3MHd2ZjNwcWptZ2kzNzFhNyJ9.ctks2LJ7nJvRGaC1YaR2fw',
                        'id': 'mapbox.satellite'
                      }),
                  MarkerLayerOptions(
                    markers:
                        List.generate(orderData.orderDataList.length, (index) {
                      var listy = orderData.orderDataList[index];
                      if (listy['approved'] == 'true') {
                        return Marker(
                            width: 200.0,
                            height: 200.0,
                            point: latLng.LatLng(
                                listy["latitude"], listy["longitude"]),
                            builder: (ctx) => Container(
                                  child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (builder) {
                                            return Container(
                                              height: 100,
                                              width: double.infinity,
                                              color: Color.fromARGB(
                                                  255, 198, 170, 245),
                                              margin: EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    height: 100,
                                                    width: 100,
                                                    child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: Image(
                                                        image: NetworkImage(
                                                            listy['foodimage']),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 50),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          'NAME : ${listy['foodname']}',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      17,
                                                                      15,
                                                                      15))),
                                                      Text(
                                                          'PRICE : ${listy['foodprice']} Rs',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      0,
                                                                      0,
                                                                      0))),
                                                      Text(
                                                          'QUANTITY : ${listy['foodnos']}',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      11,
                                                                      8,
                                                                      8))),
                                                      Text(
                                                          'TYPE : ${listy['foodtype']}',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      1,
                                                                      1,
                                                                      1))),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                )
                            // builder: (ctx) => Icon(
                            //   Icons.location_on,
                            //   color: Colors.red,
                            // )
                            );
                      } else {
                        return Marker(
                            width: 200.0,
                            height: 200.0,
                            point: latLng.LatLng(
                                listy["latitude"], listy["longitude"]),
                            builder: (ctx) => Container(
                                  child: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (builder) {
                                            return Container(
                                              height: 100,
                                              width: double.infinity,
                                              margin: EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    height: 100,
                                                    width: 100,
                                                    child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: Image(
                                                        image: NetworkImage(
                                                            listy['foodimage']),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 50),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          'NAME : ${listy['foodname']}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      Text(
                                                          'PRICE : ${listy['foodprice']} Rs',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      Text(
                                                          'QUANTITY : ${listy['foodnos']}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      Text(
                                                          'TYPE : ${listy['foodtype']}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ));
                      }
                    }),
                  )
                ])
          : Center(child: CircularProgressIndicator()),
    );
  }
}
