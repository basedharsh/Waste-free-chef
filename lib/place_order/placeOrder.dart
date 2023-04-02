import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';



final PlacedOrderDetails = <String, dynamic>{
  "providerId": "",
  "customerId": "",
  "orderId": "",
  "orderQuantity": 1,
  "orderPrice": 0,
  "apporived": false,
  "status": "onHold",
  "contactNumber": "",
  "contactName": "",
  "foodImage": "",
  "foodName": ""
};

TextEditingController contactNumber = TextEditingController();
TextEditingController contactName = TextEditingController();
TextEditingController contactEmail = TextEditingController();

final db = FirebaseFirestore.instance;
var orderDetails;


class PlaceOrderPage extends StatefulWidget {
  PlaceOrderPage({required this.custId, required this.provId, required this.ordId, required this.ordD}){
    PlacedOrderDetails['customerId'] = this.custId;
    PlacedOrderDetails['providerId'] = this.provId;
    PlacedOrderDetails['orderId'] = this.ordId;
    orderDetails = this.ordD;
  }

  String custId;
  String provId;
  String ordId;
  var ordD;

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  @override
  Widget build(BuildContext context) {
    print(orderDetails.data());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlaceOrderPageApp(),
    );
  }
}


class PlaceOrderPageApp extends StatefulWidget {
  const PlaceOrderPageApp({Key? key}) : super(key: key);

  @override
  State<PlaceOrderPageApp> createState() => _PlaceOrderPageAppState();
}

class _PlaceOrderPageAppState extends State<PlaceOrderPageApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Currently Available Food Details"),
              Image(image: NetworkImage(orderDetails.data()['foodimage']),height: 300),
              Text("Available Quantity : " + orderDetails.data()['foodnos']),
              Text("Current Price : " + orderDetails.data()['foodprice']),
              Text("Expiry Date : " + orderDetails.data()['expirydate']),
              SizedBox(height: 20),
              Center(child: Text("Place Order")),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(
                  color: Color.fromARGB(255, 227, 233, 236),
                ),
                controller: contactName,
                decoration: InputDecoration(
                  hintText: 'Contact Name',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 139, 13, 236),
                    // align the text to the left instead of centered
                  ),
                  labelText: 'Contact Name',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 139, 13, 236),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 230, 230, 230),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(
                  color: Color.fromARGB(255, 227, 233, 236),
                ),
                controller: contactNumber,
                decoration: InputDecoration(
                  hintText: 'Contact Number',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 139, 13, 236),
                    // align the text to the left instead of centered
                  ),
                  labelText: 'Contact Number',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 139, 13, 236),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 230, 230, 230),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(
                  color: Color.fromARGB(255, 227, 233, 236),
                ),
                controller: contactEmail,
                decoration: InputDecoration(
                  hintText: 'Contact Email',
                  hintStyle: TextStyle(
                    color: Color.fromARGB(255, 139, 13, 236),
                    // align the text to the left instead of centered
                  ),
                  labelText: 'Contact Email',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 139, 13, 236),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 230, 230, 230),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(child: Text("Quantity : " + PlacedOrderDetails['orderQuantity'].toString())),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(  //To only change a few things
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 30),
                    thumbColor: Color(0xFFEB1555),
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Color(0xFF8D8E98),
                    overlayColor: Color(0x29EB1555)
                ),
                child: Slider(
                    value: PlacedOrderDetails['orderQuantity'].toDouble(),
                    min: 1,
                    max: double.parse(orderDetails.data()['foodnos']),
                    onChanged: (double quantity){
                      setState(() {
                        PlacedOrderDetails['orderQuantity'] = quantity.round();
                        PlacedOrderDetails['orderPrice'] = ( int.parse(orderDetails.data()['foodprice']) / int.parse(orderDetails.data()['foodnos']) * PlacedOrderDetails['orderQuantity'] ).round();
                      });
                    }),
              ),
              Center(child: (orderDetails.data()['foodprice'] != "0")?
              Text("Order Price : " + PlacedOrderDetails['orderPrice'].toString() ):
              Text("0")),
              SizedBox(height: 20),
              Center(child: Text("Contact The Provider Before Placing Order")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: ()async{
                      await launchUrl(Uri.parse('https://wa.me/91${orderDetails.data()['providernumber']}?text=Hi! I wanted to place an order'),
                          mode: LaunchMode.externalApplication);
                    },
                    child: Icon(Icons.chat),
                    color: Colors.pink,
                  ),
                  SizedBox(width: 20),
                  MaterialButton(
                    onPressed: ()async{
                      String emailId;
                      db.collection("users").doc(orderDetails.data()['providerid']).get().then(
                              (value) => {
                              emailId = value.data()!["emailAddress"]
                              }
                      );
                      Email email = Email(
                        body: 'I would like to place an order for ${orderDetails.data()['foodname']}.'
                            ' The details of the order as as follows:'
                            '\nName - ${contactName.text.trim()}'
                            '\nEmail - ${contactEmail.text.trim()}'
                            '\nNumber - ${contactNumber.text.trim()}'
                            '\nQuantity - ${PlacedOrderDetails['orderQuantity']}'
                            '\nPrice - ${PlacedOrderDetails['orderPrice']}',
                        subject: 'Mail to Confirm Order',
                        recipients: ['emailId'],
                        isHTML: false,
                      );
                      await FlutterEmailSender.send(email);
                    },
                    child: Icon(Icons.mail),
                    color: Colors.pink,
                  ),
                  SizedBox(width: 20),
                  MaterialButton(
                    onPressed: ()async{
                      bool? res = await FlutterPhoneDirectCaller.callNumber(orderDetails.data()['providernumber']);
                    },
                    child: Icon(Icons.phone),
                    color: Colors.pink,
                  ),
                ],
              ),

              MaterialButton(
                  onPressed: ()async{

                    PlacedOrderDetails['contactName'] = contactName.text.trim();
                    PlacedOrderDetails['contactNumber'] = contactNumber.text.trim();
                    PlacedOrderDetails['contactEmail'] = contactEmail.text.trim();
                    PlacedOrderDetails['foodImage'] = orderDetails.data()['foodimage'];
                    PlacedOrderDetails['foodName'] = orderDetails.data()['foodname'];

                    await db
                        .collection('customerOrder')
                        .doc(PlacedOrderDetails['orderId'] + PlacedOrderDetails['customerId'])
                        .set(PlacedOrderDetails)
                        .onError((e, _) => print("Error In Placing Order: $e"));


                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Order Placed"),));
                  },
                child: Text("Place Order"),
                color: Colors.pink,
              )
            ],
          ),
        ),
      )
    );
  }
}
