import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/order_display/getDataFromDatabaseFunction.dart';
import 'package:firebase/order_display/orderDataList.dart';
import 'package:firebase/order_display/orderFilteringFunctions.dart';
import 'package:flutter/material.dart';
import 'package:firebase/order_display/getUserLocationFunction.dart';
import 'package:firebase/order_display/deleteExpiredFromDatabaseFunction.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase/order_display/distanceFilteringFunction.dart';

import '../models/price_model.dart';
import 'filter_page.dart';

RefreshController _refreshController = RefreshController(initialRefresh: false);

final db = FirebaseFirestore.instance;

Color diselectedPriceColor = Color.fromARGB(255, 200, 165, 253);
Color selectedPriceColor = Color.fromARGB(255, 250, 125, 253);

var orderData = OrderDataList();
var currentLatitude;
var currentLongitude;
var listy;
bool loading = true;
bool vegFilter = true;
bool lunchFliter = false;
bool snacksFliter = false;
bool dinnerFliter = false;
bool applyFilter = false;
var priceFilter = "";

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
      listy = DistanceFilter(list: orderData.orderDataList);
      if (applyFilter) {
        if (lunchFliter || snacksFliter || dinnerFliter) {
          listy = CategoryFilter(
              list: listy, l: lunchFliter, s: snacksFliter, d: dinnerFliter);
        }
        if (priceFilter != "") {
          listy = PriceFilter(list1: listy, p: priceFilter);
        }
      }
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
    // write media query here

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
              listy = DistanceFilter(list: orderData.orderDataList);
              if (applyFilter) {
                if (lunchFliter || snacksFliter || dinnerFliter) {
                  listy = CategoryFilter(
                      list: listy,
                      l: lunchFliter,
                      s: snacksFliter,
                      d: dinnerFliter);
                }
                if (priceFilter != "") {
                  listy = PriceFilter(list1: listy, p: priceFilter);
                }
              }
            });
          });
          _refreshController.refreshCompleted();
        },
        child: Column(
          children: [
            SizedBox(height: 2),
            InkWell(
              onTap: () {},
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: 200,
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: Color.fromARGB(255, 255, 38, 38)),
                  child: Column(
                    children: [
                      SizedBox(height: 14),
                      Image.asset("images/band.gif", height: 100, width: 300),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Waste",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
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
                                  color: Color.fromARGB(255, 255, 253, 253),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(
                        color: Color.fromARGB(255, 255, 255, 255),
                        thickness: 0.7,
                        indent: 40,
                        endIndent: 40,
                      ),
                      Text(
                        "Food for the needy",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 252, 252),
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
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
                      _showBottomSheet();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => FilterScreen()),
                      // );
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
                            return Material(
                              elevation: 3,
                              borderRadius: BorderRadius.circular(80),
                              child: Container(
                                // add border radius
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    color: Color.fromARGB(255, 254, 197, 187)),
                                height: 350,
                                width: 250,
                                // color: Color.fromARGB(255, 238, 139, 255),
                                // Add gap between each order
                                margin: EdgeInsets.all(2),
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
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                          child: Image(
                                            image: NetworkImage(listy
                                                .elementAt(index)
                                                .data()['foodimage']),
                                          ),
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
            SizedBox(height: 5),
            Divider(
              color: Color.fromARGB(255, 139, 139, 139),
              indent: 25, //spacing at the start of divider
              endIndent: 25,
              thickness: 1,
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

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.purple.shade50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  "Filter",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.purple,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.filter_alt,
                        color: Color.fromARGB(255, 74, 61, 155)),
                    SizedBox(width: 10),
                    Text(
                      "Price",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                CustomFilterPrice(prices: Price.prices),
                Row(
                  children: [
                    Icon(Icons.swipe_left,
                        color: Color.fromARGB(255, 74, 61, 155)),
                    SizedBox(width: 10),
                    Text(
                      "Preferences",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Veg",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'BebasNeue',
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                    Text(
                      "Non-Veg",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(255, 18, 17, 18),
                      ),
                    ),
                    Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        color: Color.fromARGB(255, 74, 61, 155)),
                    SizedBox(width: 10),
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Lunch',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Checkbox(
                              value: lunchFliter,
                              onChanged: (value) {
                                setState(() {
                                  lunchFliter = value!;
                                });
                                print(lunchFliter);
                              }),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Dinner',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Checkbox(
                              value: dinnerFliter,
                              onChanged: (value) {
                                setState(() {
                                  dinnerFliter = value!;
                                });
                              }),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Snacks',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Checkbox(
                              value: snacksFliter,
                              onChanged: (value) {
                                setState(() {
                                  snacksFliter = value!;
                                });
                              }),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       'Breakfast',
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //         fontWeight: FontWeight.bold,
                      //         fontFamily: 'Roboto',
                      //         color: Color.fromARGB(255, 0, 0, 0),
                      //       ),
                      //     ),
                      //     Checkbox(value: false, onChanged: (value) {}),
                      //   ],
                      // ),
                      SizedBox(height: 10),
                      //Location range enter manually container

                      // Apply Button Container
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          //Location range enter manually container

                          // Apply Button Container
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 200, 165, 253),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    applyFilter = true;
                                  });
                                },
                                child: Text(
                                  'Apply',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                )),
                          ),

                          SizedBox(width: 30),
                          //Location range enter manually container

                          // Apply Button Container
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 200, 165, 253),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    applyFilter = false;
                                    lunchFliter = false;
                                    snacksFliter = false;
                                    dinnerFliter = false;
                                    priceFilter = "";
                                  });
                                },
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto',
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          });
        });
  }
}

class CustomFilterPrice extends StatelessWidget {
  final List<Price> prices;
  const CustomFilterPrice({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: prices
          .map((price) => InkWell(
                onTap: () {
                  priceFilter = price.price;
                  print(priceFilter);
                  for (var p in prices) {
                    p.boxColor = diselectedPriceColor;
                  }
                  (price.boxColor == diselectedPriceColor)
                      ? price.boxColor = selectedPriceColor
                      : price.boxColor = diselectedPriceColor;
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(
                    color: price.boxColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    price.price,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}



//Statefull Karna Padega Price Wale Class ko(Try kiys mene but nahi hua)
// class CustomFilterPrice extends StatefulWidget {
//   final List<Price> prices;
//   CustomFilterPrice({super.key, required this.prices});
//
//   @override
//   State<CustomFilterPrice> createState() => _CustomFilterPriceState();
// }
//
// class _CustomFilterPriceState extends State<CustomFilterPrice> {
//    //final List<Price> prices1;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: CustomFilterPrice(prices: [
//         Price(id: 1, price: '\0',boxColor: diselectedPriceColor),
//         Price(id: 2, price: '<200',boxColor: diselectedPriceColor),
//         Price(id: 3, price: '>200',boxColor: diselectedPriceColor),
//       ],).prices
//           .map((price) => InkWell(
//         onTap: () {
//           priceFilter = price.price;
//           print(priceFilter);
//           setState(() {
//             print("colorrrrr");
//             (price.boxColor==diselectedPriceColor)?price.boxColor=selectedPriceColor:price.boxColor=diselectedPriceColor;
//           });
//         },
//         child: Container(
//           margin: const EdgeInsets.only(top: 10, bottom: 10),
//           padding:
//           const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//           decoration: BoxDecoration(
//             color: price.boxColor,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Text(
//             price.price,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Roboto',
//               color: Color.fromARGB(255, 0, 0, 0),
//             ),
//           ),
//         ),
//       ))
//           .toList(),
//     );
//   }
// }