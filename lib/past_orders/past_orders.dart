import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../order_display/orderDataList.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

Email email = Email(
  body: 'Your Order is Confirmed. Please pickup before the expiry date.',
  subject: 'Order Confirmed',
  recipients: ['shrivatsa.d@somaiya.edu'],
  isHTML: false,
);



final db = FirebaseFirestore.instance;
var orderData = OrderDataList();
var customerOrdersData = OrderDataList();
var currentUser;
var listy;
var customerListy;
var originalOrderDetails;

void GetDataFromDatabasePastOrder() async {
  await db.collection("users").get().then((event) {
    currentUser = FirebaseAuth.instance.currentUser;
  });

  await db.collection("sellerOrder").get().then((event) {
    orderData.orderDataList = event.docs;
    listy = orderData.orderDataList;
  });

  await db.collection("customerOrder").get().then((event) {
    customerOrdersData.orderDataList = event.docs;
    customerListy = customerOrdersData.orderDataList;
  });
}

class PastOrders extends StatefulWidget {
  const PastOrders({Key? key}) : super(key: key);

  @override
  State<PastOrders> createState() => _PastOrdersState();
}

class _PastOrdersState extends State<PastOrders> {
  @override
  void initState() {
    super.initState();
    GetDataFromDatabasePastOrder();
    setState(() {
      listy = listy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
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
    RefreshController _refreshPastOrdersController = RefreshController(initialRefresh: true);
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      body: SmartRefresher(
        controller: _refreshPastOrdersController,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          setState(() {
            GetDataFromDatabasePastOrder();
          });
          _refreshPastOrdersController.refreshCompleted();
        },
        child: SafeArea(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Requested Orders:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(
                  color: Color.fromARGB(153, 154, 123, 123),
                  thickness: 0.7,
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: (customerListy != null)
                        ? (customerListy.length != 0)
                            ? Row(
                                children: List.generate(customerListy.length,
                                    (index) {
                                if (customerListy
                                            .elementAt(index)
                                            .data()["apporived"] ==
                                        false &&
                                    customerListy
                                            .elementAt(index)
                                            .data()["providerId"] ==
                                        currentUser.uid) {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          opacity: 0.35,
                                          image: NetworkImage(customerListy
                                              .elementAt(index)
                                              .data()['foodImage']),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      height: 200,
                                      width: 400,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Name : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['contactName'],
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Email : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['contactEmail'],
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Number : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['contactNumber'],
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Food Name : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['foodName'],
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Quantity : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['orderQuantity']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Price : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['orderPrice']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MaterialButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'customerOrder')
                                                      .doc(
                                                          customerListy
                                                                      .elementAt(
                                                                          index)
                                                                      .data()[
                                                                  'orderId'] +
                                                              customerListy
                                                                      .elementAt(
                                                                          index)
                                                                      .data()[
                                                                  'customerId'])
                                                      .update({
                                                    "apporived": true,
                                                    "status": "pickupReady"
                                                  }).then((result) {
                                                    print(
                                                        "Order Status Updated");
                                                  }).catchError((onError) {
                                                    print("onError");
                                                  });

                                                  originalOrderDetails = await db
                                                      .collection("sellerOrder")
                                                      .doc(customerListy
                                                          .elementAt(index)
                                                          .data()['orderId'])
                                                      .get();

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('sellerOrder')
                                                      .doc(customerListy
                                                          .elementAt(index)
                                                          .data()['orderId'])
                                                      .update({
                                                    "foodnos": (int.parse(
                                                                originalOrderDetails
                                                                        .data()[
                                                                    'foodnos']) -
                                                            customerListy
                                                                    .elementAt(
                                                                        index)
                                                                    .data()[
                                                                'orderQuantity'])
                                                        .toString(),
                                                    "foodprice": (int.parse(
                                                                originalOrderDetails
                                                                        .data()[
                                                                    'foodprice']) -
                                                            customerListy
                                                                    .elementAt(
                                                                        index)
                                                                    .data()[
                                                                'orderPrice'])
                                                        .toString()
                                                  }).then((result) {
                                                    print(
                                                        "Original Order Updated");
                                                  }).catchError((onError) {
                                                    print("onError");
                                                  });

                                                  Email confirmationEmail =
                                                      Email(
                                                    body:
                                                        'Your Order is Confirmed. Please pickup before the expiry date. Your order details are:\nQuantity - ${customerListy.elementAt(index).data()['orderQuantity']}\nPrice - ${customerListy.elementAt(index).data()['orderPrice']}\nOrder ID - ${customerListy.elementAt(index).id}',
                                                    subject: 'Order Confirmed',
                                                    recipients: [
                                                      customerListy
                                                              .elementAt(index)
                                                              .data()[
                                                          'contactEmail']
                                                    ],
                                                    isHTML: false,
                                                  );

                                                  await FlutterEmailSender.send(
                                                      confirmationEmail);

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Order approved for pickup")));
                                                },
                                                child: Text("Approve"),
                                                color: Colors.deepPurple.shade100,
                                                minWidth: 10,
                                              ),
                                              SizedBox(width: 20),
                                              MaterialButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'customerOrder')
                                                      .doc(
                                                          customerListy
                                                                      .elementAt(
                                                                          index)
                                                                      .data()[
                                                                  'orderId'] +
                                                              customerListy
                                                                      .elementAt(
                                                                          index)
                                                                      .data()[
                                                                  'customerId'])
                                                      .delete();

                                                  Email email = Email(
                                                    body:
                                                        'Sorry, your Order request is not approved',
                                                    subject: 'Order Declined',
                                                    recipients: [
                                                      customerListy
                                                              .elementAt(index)
                                                              .data()[
                                                          'contactEmail']
                                                    ],
                                                    isHTML: false,
                                                  );

                                                  await FlutterEmailSender.send(
                                                      email);

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Order request declined")));
                                                },
                                                child: Text("Decline"),
                                                color: Colors.deepPurple.shade100,
                                                minWidth: 10,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
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
                                children: [Text("No past orders")],
                              ))
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [Text("Refresh the page!")],
                          ))),
                SizedBox(height: 30),
                Divider(
                  color: Color.fromARGB(96, 0, 0, 0),
                  thickness: 1.2,
                ),
                Text("Pick-up Ready Orders :",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: (customerListy != null)
                        ? (customerListy.length != 0)
                            ? Row(
                                children: List.generate(customerListy.length,
                                    (index) {
                                if (customerListy
                                            .elementAt(index)
                                            .data()["apporived"] ==
                                        true &&
                                    customerListy
                                            .elementAt(index)
                                            .data()["providerId"] ==
                                        currentUser.uid) {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 200,
                                      width: 400,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          opacity: 0.35,
                                          image: NetworkImage(customerListy
                                              .elementAt(index)
                                              .data()['foodImage']),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Name : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['contactName'],
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Email : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['contactEmail'],
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Number : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['contactNumber'],
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Food Name : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['foodName'],
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Quantity : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['orderQuantity']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Text("Price : " +
                                              customerListy
                                                  .elementAt(index)
                                                  .data()['orderPrice']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 8, 8, 8),
                                                  fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MaterialButton(
                                                onPressed: () {},
                                                child: Text("Delivered"),
                                                color: Colors.deepPurple.shade100,
                                                minWidth: 10,
                                              ),
                                              SizedBox(width: 20),
                                              MaterialButton(
                                                onPressed: () async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'customerOrder')
                                                      .doc(
                                                          customerListy
                                                                      .elementAt(
                                                                          index)
                                                                      .data()[
                                                                  'orderId'] +
                                                              customerListy
                                                                      .elementAt(
                                                                          index)
                                                                      .data()[
                                                                  'customerId'])
                                                      .update({
                                                    "apporived": false,
                                                    "status": "onHold"
                                                  }).then((result) {
                                                    print(
                                                        "Order Status Updated");
                                                  }).catchError((onError) {
                                                    print("onError");
                                                  });

                                                  originalOrderDetails = await db
                                                      .collection("sellerOrder")
                                                      .doc(customerListy
                                                          .elementAt(index)
                                                          .data()['orderId'])
                                                      .get();

                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('sellerOrder')
                                                      .doc(customerListy
                                                          .elementAt(index)
                                                          .data()['orderId'])
                                                      .update({
                                                    "foodnos": (int.parse(
                                                                originalOrderDetails
                                                                        .data()[
                                                                    'foodnos']) +
                                                            customerListy
                                                                    .elementAt(
                                                                        index)
                                                                    .data()[
                                                                'orderQuantity'])
                                                        .toString(),
                                                    "foodprice": (int.parse(
                                                                originalOrderDetails
                                                                        .data()[
                                                                    'foodprice']) +
                                                            customerListy
                                                                    .elementAt(
                                                                        index)
                                                                    .data()[
                                                                'orderPrice'])
                                                        .toString()
                                                  }).then((result) {
                                                    print(
                                                        "Original Order Updated");
                                                  }).catchError((onError) {
                                                    print("onError");
                                                  });

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Order waiting for approval")));
                                                },
                                                child: Text("Decline"),
                                                color: Colors.deepPurple.shade100,
                                                minWidth: 10,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
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
                                children: [Text("No past orders")],
                              ))
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [Text("Refresh the page")],
                          ))),
                SizedBox(height: 30),
                Divider(
                  color: Color.fromARGB(96, 0, 0, 0),
                  thickness: 1.2,
                ),
                Text("Orders You Have Placed:",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: (listy != null && currentUser != null)
                        ? (listy.length != 0)
                            ? Row(
                                children: List.generate(listy.length, (index) {
                                //var listy = orderData.orderDataList[index];
                                if (listy.elementAt(index).data()["approved"] ==
                                        "true" &&
                                    listy
                                            .elementAt(index)
                                            .data()["providerid"] ==
                                        currentUser.uid) {
                                  return Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(80),
                                          color: Colors.deepPurple.shade100,
                                        ),
                                    height: 380,
                                    width: 250,
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          // background image to container

                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 250,
                                          width: 250,
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: ClipRRect(
                                              borderRadius:
                                              // Only top left corner
                                              BorderRadius.only(
                                                topLeft: Radius.circular(80),
                                                topRight: Radius.circular(80),
                                              ),
                                              child: Image(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  listy
                                                      .elementAt(index)
                                                      .data()['foodimage'],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                            'NAME : ${listy.elementAt(index).data()['foodname']}',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 8, 8, 8),
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            'PRICE : ${listy.elementAt(index).data()['foodprice']} Rs',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 8, 8, 8),
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            'QUANTITY : ${listy.elementAt(index).data()['foodnos']}',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 8, 8, 8),
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            'TYPE : ${listy.elementAt(index).data()['foodtype']}',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 8, 8, 8),
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ));
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
                                children: [Text("No past orders")],
                              ))
                        : Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [Text("Refresh the page")],
                          ))),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
