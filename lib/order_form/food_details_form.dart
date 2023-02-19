//import 'dart:html';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/order_display/orders_display.dart';
import 'package:firebase/order_display/orderDataList.dart';
import 'package:firebase/routing/routing.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final db = FirebaseFirestore.instance;
var orderData = OrderDataList();
var uuid = Uuid();

void GetDataFromDatabase()async{
  await db.collection("sellerOrder").get().then((event) {
    orderData.orderDataList = event.docs;
  });
}

final details = <String, dynamic>{
  "foodname": "",
  "foodprice": "",
  "foodnos": "",
  "foodtype": "",
  "foodimage": ""
};

String foodImageUrl = '';
//List<QueryDocumentSnapshot>? orderDataList;


TextEditingController foodName = TextEditingController();
TextEditingController foodPrice = TextEditingController();
TextEditingController nos = TextEditingController();
TextEditingController foodType = TextEditingController();





class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  void initState(){
    GetDataFromDatabase();
    super.initState();
  }
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: foodName,
                decoration: InputDecoration(
                  hintText: 'Food Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
              TextFormField(
                controller: foodPrice,
                decoration: InputDecoration(
                  hintText: 'Food Price',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
              TextFormField(
                controller: nos,
                decoration: InputDecoration(
                  hintText: 'Food Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
              TextFormField(
                controller: foodType,
                decoration: InputDecoration(
                  hintText: 'Food Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                  onPressed: ()async{

                    ImagePicker imagePicker = ImagePicker();
                    XFile? foodimage = await imagePicker.pickImage(source: ImageSource.gallery);
                    print(foodimage?.path);

                    if(foodimage==null) return;

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceImageDir = referenceRoot.child('foodImage');
                    Reference referenceImageToUpload = referenceImageDir.child(uuid.v1());


                    try{
                      await referenceImageToUpload.putFile(File(foodimage!.path) as File);
                      foodImageUrl = await referenceImageToUpload.getDownloadURL();
                    }catch(error){

                    }


                  },
                child: Text("Image"),
                color: Colors.red,
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: ()async{
                  details['foodname'] = foodName.text.trim();
                  details['foodprice'] = foodPrice.text.trim();
                  details['foodnos'] = nos.text.trim();
                  details['foodtype'] = foodType.text.trim();
                  details['foodimage'] = foodImageUrl;

                  db
                      .collection('sellerOrder')
                      .doc(uuid.v1())
                      .set(details)
                      .onError((e, _) => print("Error In Placing Order: $e"));

                  await db.collection("sellerOrder").get().then((event) {
                    orderData.orderDataList = event.docs;
                  });

                },
                child: Text("Submit"),
                color: Colors.red,
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: ()async{
                  await db.collection("sellerOrder").get().then((event) {
                    //orderData.orderDataList = event.docs;
                    for (var doc in event.docs) {
                      print("${doc.id} => ${doc.data()}");
                    }
                  });
                },
                color: Colors.red,
                child: Text("Output"),
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: (){
                  GetDataFromDatabase();
                  RoutingPage.goToNext(context: context, navigateTo: OrdersDisplay());
                },
                color: Colors.red,
                child: Text("Show Orders"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}







