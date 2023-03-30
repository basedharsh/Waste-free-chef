import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../order_display/orderDataList.dart';


RefreshController _refreshPastOrdersController = RefreshController(initialRefresh: false);


final db = FirebaseFirestore.instance;
var orderData = OrderDataList();
var customerOrdersData = OrderDataList();
var currentUser;
var listy;
var customerListy;
var originalOrderDetails;

void GetDataFromDatabase()async{
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
  void initState(){
    super.initState();
    GetDataFromDatabase();
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
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshPastOrdersController,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1000));
          setState(() {
            GetDataFromDatabase();
          });
          _refreshPastOrdersController.refreshCompleted();
        },
        child: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer Orders for approval"),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: (customerListy!=null)?(customerListy.length!=0)?
                      Row(
                          children:  List.generate(customerListy.length,(index){
                            if(customerListy.elementAt(index).data()["apporived"]==false && customerListy.elementAt(index).data()["providerId"]==currentUser.uid ){
                              return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 200,
                                      width: 200,
                                      color: Colors.pink,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("CustomerId : " + customerListy.elementAt(index).data()['customerId']),
                                          Text("OrderId : "+ customerListy.elementAt(index).data()['orderId']),
                                          Text("Quantity : " + customerListy.elementAt(index).data()['orderQuantity'].toString()),
                                          Text("Price : " + customerListy.elementAt(index).data()['orderPrice'].toString()),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              MaterialButton(
                                                onPressed: ()async{

                                                  await FirebaseFirestore.instance
                                                      .collection('customerOrder')
                                                      .doc(customerListy.elementAt(index).data()['orderId'] + customerListy.elementAt(index).data()['customerId'])
                                                      .update({
                                                    "apporived": true,
                                                    "status": "pickupReady"
                                                  }).then((result){
                                                    print("Order Status Updated");
                                                  }).catchError((onError){
                                                    print("onError");
                                                  });

                                                  originalOrderDetails = await db
                                                      .collection("sellerOrder")
                                                      .doc(customerListy.elementAt(index).data()['orderId'])
                                                      .get();

                                                  await FirebaseFirestore.instance
                                                      .collection('sellerOrder')
                                                      .doc(customerListy.elementAt(index).data()['orderId'])
                                                      .update({
                                                    "foodnos": (int.parse(originalOrderDetails.data()['foodnos']) - customerListy.elementAt(index).data()['orderQuantity']).toString(),
                                                    "foodprice": (int.parse(originalOrderDetails.data()['foodprice']) - customerListy.elementAt(index).data()['orderPrice']).toString()
                                                  }).then((result){
                                                    print("Original Order Updated");
                                                  }).catchError((onError){
                                                    print("onError");
                                                  });

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(content: Text("Order approved for pickup")));

                                                },
                                                child: Icon(Icons.check),
                                                color: Colors.green,
                                                minWidth: 10,
                                              ),
                                              SizedBox(width: 20),
                                              MaterialButton(
                                                onPressed: ()async{

                                                  await FirebaseFirestore.instance
                                                      .collection('customerOrder')
                                                      .doc(customerListy.elementAt(index).data()['orderId'] + customerListy.elementAt(index).data()['customerId'])
                                                      .delete();

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(content: Text("Order request declined")));

                                                },
                                                child: Icon(Icons.close),
                                                color: Colors.redAccent,
                                                minWidth: 10,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
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
                        children: [Text("No past orders")],
                      )):Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [Text("Refresh the page")],
                      ))
                  ),
                  SizedBox(height: 30),

                  Text("Orders ready for pickup"),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: (customerListy!=null)?(customerListy.length!=0)?
                      Row(
                          children:  List.generate(customerListy.length,(index){
                            if(customerListy.elementAt(index).data()["apporived"]==true && customerListy.elementAt(index).data()["providerId"]==currentUser.uid ){
                              return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 200,
                                      width: 200,
                                      color: Colors.pink,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("CustomerId : " + customerListy.elementAt(index).data()['customerId'].toString()),
                                          Text("OrderId : "+ customerListy.elementAt(index).data()['orderId'].toString()),
                                          Text("Quantity : " + customerListy.elementAt(index).data()['orderQuantity'].toString()),
                                          Text("Price : " + customerListy.elementAt(index).data()['orderPrice'].toString()),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              MaterialButton(
                                                onPressed: (){

                                                },
                                                child: Icon(Icons.check),
                                                color: Colors.green,
                                                minWidth: 10,
                                              ),
                                              SizedBox(width: 20),
                                              MaterialButton(
                                                onPressed: ()async{

                                                  await FirebaseFirestore.instance
                                                      .collection('customerOrder')
                                                      .doc(customerListy.elementAt(index).data()['orderId'] + customerListy.elementAt(index).data()['customerId'])
                                                      .update({
                                                    "apporived": false,
                                                    "status": "onHold"
                                                  }).then((result){
                                                    print("Order Status Updated");
                                                  }).catchError((onError){
                                                    print("onError");
                                                  });

                                                  originalOrderDetails = await db
                                                      .collection("sellerOrder")
                                                      .doc(customerListy.elementAt(index).data()['orderId'])
                                                      .get();

                                                  await FirebaseFirestore.instance
                                                      .collection('sellerOrder')
                                                      .doc(customerListy.elementAt(index).data()['orderId'])
                                                      .update({
                                                    "foodnos": (int.parse(originalOrderDetails.data()['foodnos']) + customerListy.elementAt(index).data()['orderQuantity']).toString(),
                                                    "foodprice": (int.parse(originalOrderDetails.data()['foodprice']) + customerListy.elementAt(index).data()['orderPrice']).toString()
                                                  }).then((result){
                                                    print("Original Order Updated");
                                                  }).catchError((onError){
                                                    print("onError");
                                                  });

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(content: Text("Order waiting for approval")));


                                                },
                                                child: Icon(Icons.close),
                                                color: Colors.redAccent,
                                                minWidth: 10,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
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
                        children: [Text("No past orders")],
                      )):Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [Text("Refresh the page")],
                      ))
                  ),


                  SizedBox(height: 30),
                  Text("Currently Placed Orders"),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: (listy!=null && currentUser!=null)?(listy.length!=0)?
                      Row(
                          children:  List.generate(listy.length,(index){
                            //var listy = orderData.orderDataList[index];
                            if(listy.elementAt(index).data()["approved"]=="true" && listy.elementAt(index).data()["providerid"]==currentUser.uid){
                              return Center(
                                  child: Container(
                                    height: 450,
                                    width: 250,
                                    color: Colors.pink,
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          height: 250,
                                          width: 250,
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
                        children: [Text("No past orders")],
                      )):Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [Text("Refresh the page")],
                      ))
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}

