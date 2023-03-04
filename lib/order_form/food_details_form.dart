import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/order_display/orderDataList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:location/location.dart';

final db = FirebaseFirestore.instance;
var orderData = OrderDataList();
var uuid = Uuid();
var currentUser;

void GetDataFromDatabase()async{
  await db.collection("sellerOrder").get().then((event) {
    orderData.orderDataList = event.docs;
    currentUser = FirebaseAuth.instance.currentUser;
  });
}

final details = <String, dynamic>{
  "providername": "",
  "foodname": "",
  "foodprice": "",
  "foodnos": "",
  "foodtype": "",
  "foodimage": "",
  "expirydate": "",
  "latitude": "",
  "longitude": "",
  "approved": "true",
  "providerid": ""
};

bool priceEnabled = true;

String foodImageUrl = '';

TextEditingController providerName = TextEditingController();
TextEditingController foodName = TextEditingController();
TextEditingController foodPrice = TextEditingController();
TextEditingController nos = TextEditingController();
TextEditingController foodType = TextEditingController();
TextEditingController expiryDate = TextEditingController();


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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: providerName,
                  decoration: InputDecoration(
                    hintText: 'Food Provider Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
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
                  controller: expiryDate,
                  decoration: InputDecoration(
                    hintText: 'Expiry Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onTap: ()async{
                    DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101)
                    );

                    if(pickeddate != null){
                      setState(() {
                        expiryDate.text = pickeddate.toString().split(" ")[0];
                      });
                    }
                  },
                ),
                TextFormField(
                  controller: nos,
                  decoration: InputDecoration(
                    hintText: 'Number of Serving',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.blue[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Food Type"),
                      RadioListTile(
                        title: Text("Breakfast"),
                        value: "breakfast",
                        groupValue: details['foodtype'],
                        onChanged: (value){
                          setState(() {
                            details['foodtype'] = value.toString();
                          });
                        },
                      ),

                      RadioListTile(
                        title: Text("Lunch"),
                        value: "lunch",
                        groupValue: details['foodtype'],
                        onChanged: (value){
                          setState(() {
                            details['foodtype'] = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text("Snacks"),
                        value: "snacks",
                        groupValue: details['foodtype'],
                        onChanged: (value){
                          setState(() {
                            details['foodtype'] = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text("Dinner"),
                        value: "dinner",
                        groupValue: details['foodtype'],
                        onChanged: (value){
                          setState(() {
                            details['foodtype'] = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.blue[100],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Donate or Sell"),
                      RadioListTile(
                        title: Text("Donate"),
                        value: false,
                        groupValue: priceEnabled,
                        onChanged: (value){
                          setState(() {
                            priceEnabled = false;
                          });
                        },
                      ),

                      RadioListTile(
                        title: Text("Sell"),
                        value: true,
                        groupValue: priceEnabled,
                        onChanged: (value){
                          setState(() {
                            priceEnabled = true;
                          });
                        },
                      ),
                  ]
                )
                ),
                SizedBox(height: 20),
                (priceEnabled==true)?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Enter Price"),
                        TextFormField(
                          controller: foodPrice,
                          decoration: InputDecoration(
                            hintText: 'Food Price',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        )
                      ],
                    )
                :SizedBox(),
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
                        await referenceImageToUpload.putFile(File(foodimage!.path) as File).then((value){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Image Noted")));
                        });
                        foodImageUrl = await referenceImageToUpload.getDownloadURL();
                      }catch(error){

                      }


                    },
                  child: Text("Image"),
                  color: Colors.red,
                ),
                  SizedBox(height: 20),
                  MaterialButton(
                      child: Text("Get Location"),
                     color: Colors.red,
                     onPressed: (){
                        getLocation().then((value){
                          print(value);
                          details['latitude'] = value.latitude;
                          details['longitude'] = value.longitude;
                              ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Location Noted")));
                        });
                     }),
                SizedBox(height: 20),
                MaterialButton(
                  onPressed: ()async{
                    details['providername'] = providerName.text.trim();
                    details['foodname'] = foodName.text.trim();
                    (priceEnabled==false)?details['foodprice']="0":details['foodprice'] = foodPrice.text.trim();
                    details['foodnos'] = nos.text.trim();
                    //details['foodtype'] = foodType.text.trim();
                    details['foodimage'] = foodImageUrl;
                    details['providerid'] = currentUser.uid;
                    details['expirydate'] = expiryDate.text.trim();

                        db
                        .collection('sellerOrder')
                        .doc(uuid.v1())
                        .set(details)
                        .onError((e, _) => print("Error In Placing Order: $e"));

                    await db.collection("sellerOrder").get().then((event) {
                      orderData.orderDataList = event.docs;
                    });
                    print(details);

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}