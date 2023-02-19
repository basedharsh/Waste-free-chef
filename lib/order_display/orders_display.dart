import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/order_display/orderDataList.dart';
import 'package:flutter/material.dart';

final db = FirebaseFirestore.instance;

var orderData = OrderDataList();

void GetDataFromDatabase()async{
  await db.collection("sellerOrder").get().then((event) {
    orderData.orderDataList = event.docs;
    loading = false;
    print(orderData.orderDataList);
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
    GetDataFromDatabase();
    setState(()
    {
      orderData.orderDataList = orderData.orderDataList;
    });
    super.initState();
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
  // void initState(){
  //   GetDataFromDatabase();
  //   super.initState();
  // }
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: (orderData.orderDataList.length!=0)?
            Column(
                children:  List.generate(orderData.orderDataList.length,(index){
                  var listy = orderData.orderDataList[index];
                  return Center(
                    child: Container(
                      height: 500,
                      width: 300,
                      color: Colors.red,
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
                                image: NetworkImage(listy['foodimage']),
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          Text('NAME : ${listy['foodname']}'),
                          Text('PRICE : ${listy['foodprice']} Rs'),
                          Text('QUANTITY : ${listy['foodnos']}'),
                          Text('TYPE : ${listy['foodtype']}'),
                        ],
                      ),
                    )
                  );
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