import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/order_display/getDataFromDatabaseFunction.dart';
import 'package:firebase/order_display/orderDataList.dart';
import 'package:flutter/material.dart';
import 'package:firebase/order_display/getUserLocationFunction.dart';
import 'package:firebase/order_display/deleteExpiredFromDatabaseFunction.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase/order_display/distanceFilteringFunction.dart';

import 'filter_page.dart';

RefreshController _refreshController = RefreshController(initialRefresh: false);

final db = FirebaseFirestore.instance;

var orderData = OrderDataList();
var currentLatitude;
var currentLongitude;
var listy;
bool loading = true;

class OrdersDisplay extends StatefulWidget {
  const OrdersDisplay({Key? key}) : super(key: key);
  //OrdersDisplay({required ordersist});

  @override
  State<OrdersDisplay> createState() => _OrdersDisplayState();
}

class _OrdersDisplayState extends State<OrdersDisplay> {
  @override
  void initState() {
    super.initState();
    getLocation().then((value) {
      currentLatitude = value.latitude;
      currentLongitude = value.longitude;
    });
    DeleteExpiredFromDatabase();
    setState(() {
      GetDataFromDatabase();
      listy = orderData.orderDataList;
      //listy = DistanceFilter(list: orderData.orderDataList);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building");
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyApp());
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
      backgroundColor: Color.fromARGB(255, 241, 231, 245),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          setState(() {
            getLocation().then((value) {
              currentLatitude = value.latitude;
              currentLongitude = value.longitude;
            });
            DeleteExpiredFromDatabase();
            setState(() {
              GetDataFromDatabase();
              listy = orderData.orderDataList;
              //listy = DistanceFilter(list: orderData.orderDataList);
            });
          });
          _refreshController.refreshCompleted();
        },
        child: Column(
          children: [
            SizedBox(height: 1),
            InkWell(
              onTap: () {},
              child: Container(
                height: 100,
                width: double.infinity,
                color: Color.fromARGB(255, 222, 123, 239),
                child: Column(
                  children: [
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Waste",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "-Food",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text("-Chef",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Food for the needy",
                      style: TextStyle(
                          color: Color.fromARGB(255, 23, 17, 17),
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Orders",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
                // Filter Button
                Container(
                  child: IconButton(
                    icon:
                        Icon(Icons.filter_alt, color: Colors.purple, size: 30),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FilterScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: (listy.length != 0)
                      ? Row(
                          children: List.generate(listy.length, (index) {
                          //var listy = orderData.orderDataList[index];
                          if (listy.elementAt(index).data()["approved"] ==
                              "true") {
                            // main container for each order
                            return Container(
                              // add border radius
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(80),
                                  color: Color.fromARGB(255, 254, 197, 187)),
                              height: 350,
                              width: 250,
                              // color: Color.fromARGB(255, 238, 139, 255),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // Image
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 200,
                                    width: 250,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image(
                                        image: NetworkImage(listy
                                            .elementAt(index)
                                            .data()['foodimage']),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                      'NAME : ${listy.elementAt(index).data()['foodname']}',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 8, 8, 8),
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      'PRICE : ${listy.elementAt(index).data()['foodprice']} Rs',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 8, 8, 8),
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      'QUANTITY : ${listy.elementAt(index).data()['foodnos']}',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 8, 8, 8),
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      'TYPE : ${listy.elementAt(index).data()['foodtype']}',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 8, 8, 8),
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      'EXPIRY DATE : ${listy.elementAt(index).data()['expirydate']}',
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 8, 8, 8),
                                          fontWeight: FontWeight.bold)),
                                  MaterialButton(
                                    onPressed: () {},
                                    child: Text("Chat"),
                                    color: Color.fromARGB(255, 226, 84, 245),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Container(
                              height: 0,
                              width: 0,
                            );
                          }
                        }))
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              color: Color.fromARGB(255, 253, 241, 255),
                              height: 200,
                              width: 350,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.not_interested_sharp,
                                    size: 100,
                                    color: Color.fromARGB(255, 218, 51, 51),
                                  ),
                                  Text(
                                    " Currently No Orders Available",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 218, 51, 51),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))),
            ),
            Text("Restaurants",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            Row(),
          ],
        ),
      ),
    );
  }
}
