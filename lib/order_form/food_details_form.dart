import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/order_display/orderDataList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:location/location.dart';

final db = FirebaseFirestore.instance;
var orderData = OrderDataList();
var uuid = Uuid();
var currentUser;

var locationClicked = false;
var locationLoading = false;
var imageClicked = false;

void GetDataFromDatabase() async {
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
  "providerid": "",
  "providernumber": ""
};

bool priceEnabled = true;

String foodImageUrl = '';

TextEditingController providerName = TextEditingController();
TextEditingController foodName = TextEditingController();
TextEditingController foodPrice = TextEditingController();
TextEditingController nos = TextEditingController();
TextEditingController foodType = TextEditingController();
TextEditingController expiryDate = TextEditingController();
TextEditingController providerNumber = TextEditingController();

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
  void initState() {
    GetDataFromDatabase();
    setState(() {
      locationClicked = false;
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          unselectedWidgetColor: Color.fromARGB(255, 227, 233, 236),
          scaffoldBackgroundColor: Colors.deepPurple.shade300,
          primarySwatch: Colors.deepPurple,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.deepPurple,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This is the style for the text in the drawer menu
  final mylabelstyle = GoogleFonts.roboto(
    textStyle: TextStyle(
      color: Colors.grey.shade900,
      fontSize: 16,
    ),
  );

  final myfocusedborder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromARGB(255, 0, 0, 0),
      width: 3,
    ),
    borderRadius: BorderRadius.circular(30.0),
    //thickness: 5,
  );

  final myenabledborder = OutlineInputBorder(
    borderSide: BorderSide(
      width: 1,
      color: Color.fromARGB(255, 0, 0, 0),
    ),
    borderRadius: BorderRadius.circular(30.0),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 5, bottom: 5, left: 0, right: 0),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade300,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {},
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 100,
                      width: 400,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("images/bg2.jpg"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: Colors.white),
                      child: Column(
                        children: [
                          SizedBox(height: 14),
                          // Image.asset("images/band.gif", height: 100, width: 300),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Waste",
                                style: TextStyle(
                                    color: Colors.deepPurple.shade900,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "-Free",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("-Chef",
                                  style: TextStyle(
                                      color: Colors.deepPurple.shade900,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(
                            color: Color.fromARGB(255, 59, 59, 59),
                            thickness: 1,
                            indent: 40,
                            endIndent: 40,
                          ),
                          Text(
                            "Place your order here",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: mylabelstyle,
                  controller: providerName,
                  decoration: InputDecoration(
                    hintText: 'Provider Name',
                    hintStyle: mylabelstyle,
                    labelText: 'Provider Name',
                    labelStyle: mylabelstyle,
                    focusedBorder: myfocusedborder,
                    enabledBorder: myenabledborder,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: mylabelstyle,
                  controller: foodName,
                  decoration: InputDecoration(
                    hintText: 'Food Name',
                    hintStyle: mylabelstyle,
                    labelText: 'Food Name',
                    labelStyle: mylabelstyle,
                    enabledBorder: myenabledborder,
                    focusedBorder: myfocusedborder,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: mylabelstyle,
                  controller: expiryDate,
                  decoration: InputDecoration(
                    hintText: 'Expiry Date',
                    hintStyle: mylabelstyle,
                    labelText: 'Expiry Date',
                    labelStyle: mylabelstyle,
                    enabledBorder: myenabledborder,
                    focusedBorder: myfocusedborder,
                  ),
                  onTap: () async {
                    DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101));

                    if (pickeddate != null) {
                      setState(() {
                        expiryDate.text = pickeddate.toString().split(" ")[0];
                      });
                    }
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: mylabelstyle,
                  controller: nos,
                  decoration: InputDecoration(
                    hintText: 'Number of Servings',
                    hintStyle: mylabelstyle,
                    labelText: 'Number of Servings',
                    labelStyle: mylabelstyle,
                    enabledBorder: myenabledborder,
                    focusedBorder: myfocusedborder,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color.fromARGB(255, 227, 233, 236),
                      )),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Food Type",
                          style: TextStyle(
                            color: Color.fromARGB(255, 139, 13, 236),
                          )),
                      RadioListTile(
                        activeColor: Color.fromARGB(255, 139, 13, 236),
                        title: Text("Breakfast", style: mylabelstyle),
                        value: "breakfast",
                        groupValue: details['foodtype'],
                        onChanged: (value) {
                          setState(() {
                            details['foodtype'] = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        activeColor: Color.fromARGB(255, 139, 13, 236),
                        title: Text("Lunch", style: mylabelstyle),
                        value: "lunch",
                        groupValue: details['foodtype'],
                        onChanged: (value) {
                          setState(() {
                            details['foodtype'] = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        activeColor: Color.fromARGB(255, 139, 13, 236),
                        title: Text("Snacks", style: mylabelstyle),
                        value: "snacks",
                        groupValue: details['foodtype'],
                        onChanged: (value) {
                          setState(() {
                            details['foodtype'] = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        activeColor: Color.fromARGB(255, 139, 13, 236),
                        title: Text("Dinner", style: mylabelstyle),
                        value: "dinner",
                        groupValue: details['foodtype'],
                        onChanged: (value) {
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromARGB(255, 227, 233, 236),
                        )),
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Donate or Sell",
                              style: TextStyle(
                                color: Color.fromARGB(255, 139, 13, 236),
                              )),
                          RadioListTile(
                            activeColor: Color.fromARGB(255, 139, 13, 236),
                            title: Text("Donate", style: mylabelstyle),
                            value: false,
                            groupValue: priceEnabled,
                            onChanged: (value) {
                              setState(() {
                                priceEnabled = false;
                              });
                            },
                          ),
                          RadioListTile(
                            activeColor: Color.fromARGB(255, 139, 13, 236),
                            title: Text("Sell", style: mylabelstyle),
                            value: true,
                            groupValue: priceEnabled,
                            onChanged: (value) {
                              setState(() {
                                priceEnabled = true;
                              });
                            },
                          ),
                        ])),
                SizedBox(height: 20),
                (priceEnabled == true)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            style: TextStyle(
                              color: Color.fromARGB(255, 227, 233, 236),
                            ),
                            controller: foodPrice,
                            decoration: InputDecoration(
                              hintText: 'Food Price',
                              hintStyle: mylabelstyle,
                              labelText: 'Food Price',
                              labelStyle: mylabelstyle,
                              enabledBorder: myenabledborder,
                              focusedBorder: myfocusedborder,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      )
                    : SizedBox(),
                TextFormField(
                  style: TextStyle(
                    color: Color.fromARGB(255, 227, 233, 236),
                  ),
                  controller: providerNumber,
                  decoration: InputDecoration(
                    hintText: 'Contact Number',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                      // align the text to the left instead of centered
                    ),
                    labelText: 'Contact Number',
                    labelStyle: mylabelstyle,
                    enabledBorder: myenabledborder,
                    focusedBorder: myfocusedborder,
                  ),
                ),
                SizedBox(height: 20),
                (imageClicked == false)
                    ? MaterialButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? foodimage = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          print(foodimage?.path);

                          if (foodimage == null) return;

                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceImageDir =
                              referenceRoot.child('foodImage');
                          Reference referenceImageToUpload =
                              referenceImageDir.child(uuid.v1());

                          try {
                            await referenceImageToUpload
                                .putFile(File(foodimage!.path) as File)
                                .then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Image Noted"),
                              ));
                            });
                            foodImageUrl =
                                await referenceImageToUpload.getDownloadURL();
                          } catch (error) {}
                          setState(() {
                            imageClicked = true;
                          });
                        },
                        child: Text("Image"),
                        color: Color.fromARGB(255, 139, 13, 236),
                      )
                    : MaterialButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? foodimage = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          print(foodimage?.path);

                          if (foodimage == null) return;

                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceImageDir =
                              referenceRoot.child('foodImage');
                          Reference referenceImageToUpload =
                              referenceImageDir.child(uuid.v1());

                          try {
                            await referenceImageToUpload
                                .putFile(File(foodimage!.path) as File)
                                .then((value) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text("Image Noted"),
                              ));
                            });
                            foodImageUrl =
                                await referenceImageToUpload.getDownloadURL();
                          } catch (error) {}
                        },
                        child: Icon(Icons.check),
                        color: Color.fromARGB(255, 139, 13, 236),
                      ),
                SizedBox(height: 20),
                (locationClicked == false)
                    ? MaterialButton(
                        child: (locationLoading == true)
                            ? CircularProgressIndicator()
                            : Text("Get Location"),
                        color: Color.fromARGB(255, 139, 13, 236),
                        onPressed: () async {
                          setState(() {
                            locationLoading = true;
                          });
                          await getLocation().then((value) {
                            print(value);
                            details['latitude'] = value.latitude;
                            details['longitude'] = value.longitude;
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Location Noted")));
                          });
                          setState(() {
                            locationClicked = true;
                            locationLoading = false;
                          });
                        })
                    : MaterialButton(
                        child: (locationLoading == true)
                            ? CircularProgressIndicator()
                            : Icon(Icons.check),
                        color: Color.fromARGB(255, 139, 13, 236),
                        onPressed: () {
                          setState(() {
                            locationLoading = true;
                          });
                          getLocation().then((value) {
                            print(value);
                            details['latitude'] = value.latitude;
                            details['longitude'] = value.longitude;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Location Noted"),
                            ));
                          });
                          setState(() {
                            locationClicked = true;
                            locationLoading = false;
                          });
                        }),
                SizedBox(height: 20),
                MaterialButton(
                  onPressed: () async {
                    if (foodImageUrl == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Input an image for food to place order")));
                    } else if (details['latitude'] == "" &&
                        details['longitude'] == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Select your Location to place order")));
                    } else {
                      details['providername'] = providerName.text.trim();
                      details['foodname'] = foodName.text.trim();
                      (priceEnabled == false)
                          ? details['foodprice'] = "0"
                          : details['foodprice'] = foodPrice.text.trim();
                      details['foodnos'] = nos.text.trim();
                      //details['foodtype'] = foodType.text.trim();
                      details['foodimage'] = foodImageUrl;
                      details['providerid'] = currentUser.uid;
                      details['expirydate'] = expiryDate.text.trim();
                      details['providernumber'] = providerNumber.text.trim();
                      details['foodimage'] = foodImageUrl;

                      db
                          .collection('sellerOrder')
                          .doc(uuid.v1())
                          .set(details)
                          .onError(
                              (e, _) => print("Error In Placing Order: $e"));

                      await db.collection("sellerOrder").get().then((event) {
                        orderData.orderDataList = event.docs;
                      });
                      print(details);
                    }

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Order Placed"),
                    ));
                  },
                  child: Text("Submit"),
                  color: Color.fromARGB(255, 139, 13, 236),
                ),
                SizedBox(height: 20),
                // MaterialButton(
                //   onPressed: ()async{
                //     await db.collection("sellerOrder").get().then((event) {
                //       //orderData.orderDataList = event.docs;
                //       for (var doc in event.docs) {
                //         print("${doc.id} => ${doc.data()}");
                //       }
                //     });
                //   },
                //   color: Colors.red,
                //   child: Text("Output"),
                // ),
                //SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
