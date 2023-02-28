import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/order_display/orderDataList.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:math';

final db = FirebaseFirestore.instance;

var orderData = OrderDataList();
var currentLatitude;
var currentLongitude;
var listy;

Iterable<QueryDocumentSnapshot> DistanceFilter(){

  // print(orderData.orderDataList.where(
  //         (element) => (
  //             calculateDistance(
  //                 lat1: currentLatitude,
  //                 long1: currentLongitude,
  //                 lat2: element["latitude"],
  //                 long2: element["longitude"])>=50)
  // )
  // );

   return orderData.orderDataList.where(
          (element) => (
          calculateDistance(
              lat1: currentLatitude,
              long1: currentLongitude,
              lat2: element["latitude"],
              long2: element["longitude"])<=20)
  );

  //print(listy.elementAt(0).data());

}


double calculateDistance({required var lat1,required var long1,required var lat2,required var long2}){
  lat1 = lat1*(3.14)/180;
  long1 = long1*(3.14)/180;
  lat2 = lat2*(3.14)/180;
  long2 = long2*(3.14)/180;

  var dlat = lat2 - lat1;
  var dlong = long2 - long1;

  var dist = pow(sin(dlat / 2), 2) +
      cos(lat1) * cos(lat2) *
          pow(sin(dlong / 2), 2);

  dist = 2 * asin(sqrt(dist));
  dist = dist*6371;

  return dist;
}


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




void GetDataFromDatabase()async{
  await db.collection("sellerOrder").get().then((event) {
    orderData.orderDataList = event.docs;
    loading = false;
    //print(orderData.orderDataList);
  });
}

bool loading = true;

class OrdersDisplay extends StatefulWidget {
  const OrdersDisplay({Key? key}) : super(key: key);

  @override
  State<OrdersDisplay> createState() => _OrdersDisplayState();
}

class _OrdersDisplayState extends State<OrdersDisplay> {

  @override
  void initState(){
    super.initState();
    getLocation().then((value) {
      currentLatitude = value.latitude;
      currentLongitude = value.longitude;
    });
    GetDataFromDatabase();

    listy = DistanceFilter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: MyApp()
    );
  }
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: (listy.length!=0)?
            Column(
                children:  List.generate(listy.length,(index){
                  //var listy = orderData.orderDataList[index];
                  if(listy.elementAt(index).data()["approved"]=="true"){
                    return Center(
                        child: Container(
                          height: 500,
                          width: 300,
                          color: Colors.lightBlue,
                          margin: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                height: 300,
                                width: 300,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image(
                                    image: NetworkImage(listy.elementAt(index).data()['foodimage']),
                                  ),
                                ),
                              ),
                              SizedBox(height: 50),
                              Text('NAME : ${listy.elementAt(index).data()['foodname']}',style: TextStyle(color: Colors.white)),
                              Text('PRICE : ${listy.elementAt(index).data()['foodprice']} Rs',style: TextStyle(color: Colors.white)),
                              Text('QUANTITY : ${listy.elementAt(index).data()['foodnos']}',style: TextStyle(color: Colors.white)),
                              Text('TYPE : ${listy.elementAt(index).data()['foodtype']}',style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        )
                    );
                  }
                  else{
                    return Container(
                      height: 0,
                      width: 0,
                    );
                  }

                })
            ):Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [CircularProgressIndicator()],
            ))
          )
      ),
    );
  }
}