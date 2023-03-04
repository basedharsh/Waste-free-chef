import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'orders_display.dart';

double calculateDistance({required var lat1,required var long1,required var lat2,required var long2}){
  var laty1 = lat1*(3.14)/180;
  var longy1 = long1*(3.14)/180;
  var laty2 = lat2*(3.14)/180;
  var longy2 = long2*(3.14)/180;

  var dlat = laty2 - laty1;
  var dlong = longy2 - longy1;

  var dist = pow(sin(dlat / 2), 2) +
      cos(lat1) * cos(lat2) *
          pow(sin(dlong / 2), 2);

  dist = 2 * asin(sqrt(dist));
  dist = dist*6371;

  return dist;
}


Iterable<QueryDocumentSnapshot> DistanceFilter({required var list}){

  return list.where(
          (element) => (
          calculateDistance(
              lat1: currentLatitude,
              long1: currentLongitude,
              lat2: element["latitude"],
              long2: element["longitude"])<=20.0)
  );

}