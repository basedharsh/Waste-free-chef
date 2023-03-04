import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../order_display/orderDataList.dart';


final db = FirebaseFirestore.instance;
var orderData = OrderDataList();
var currentUser;
var listy;

void GetDataFromDatabase()async{
  await db.collection("users").get().then((event) {
    currentUser = FirebaseAuth.instance.currentUser;
  });

  await db.collection("sellerOrder").get().then((event) {
    orderData.orderDataList = event.docs;
    listy = orderData.orderDataList;
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
    print(currentUser.uid);
    print(listy[0].data());
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: (listy.length!=0)?
              Column(
                  children:  List.generate(listy.length,(index){
                    //var listy = orderData.orderDataList[index];
                    if(listy.elementAt(index).data()["approved"]=="true" && listy.elementAt(index).data()["providerid"]==currentUser.uid){
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

