import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/order_display/getDataFromDatabaseFunction.dart';
import 'package:firebase/order_display/orderDataList.dart';
import 'package:flutter/material.dart';
import 'package:firebase/order_display/getUserLocationFunction.dart';
import 'package:firebase/order_display/deleteExpiredFromDatabaseFunction.dart';
import 'package:firebase/order_display/distanceFilteringFunction.dart';

final db = FirebaseFirestore.instance;

var orderData = OrderDataList();
var currentLatitude;
var currentLongitude;
var listy;
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
    DeleteExpiredFromDatabase();
    setState(() {
      GetDataFromDatabase();
      listy = orderData.orderDataList;
      listy = DistanceFilter(list: orderData.orderDataList);
    });
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
            child: (loading == false)?(listy.length!=0)?
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
                              Text('EXPITY DATE : ${listy.elementAt(index).data()['expirydate']}',style: TextStyle(color: Colors.white))
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
              children: [
                Text("No Orders Available Currently")
              ],
            )):Center(
              child: Column(
                children: [CircularProgressIndicator()],
              ),
            )
          )
      ),
    );
  }
}