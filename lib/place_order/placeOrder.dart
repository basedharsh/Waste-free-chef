import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';



var PlacedOrderDetails = <String, dynamic>{
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
  void initState(){
    PlacedOrderDetails['orderQuantity'] = 1;
  }


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
      backgroundColor: Colors.deepPurple.shade100,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80),bottomRight: Radius.circular(80)),
                  color: Colors.deepPurple.shade300),
              child: Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 30),
                child: Column(
                  children: [
                    Text("Currently Available Food Details",style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80)
                      ),
                      height: 300,
                      width: 300,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: ClipRRect(
                          borderRadius:
                          // Only top left corner
                          BorderRadius.circular(50),
                          child: Image(image: NetworkImage(orderDetails.data()['foodimage']))
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Available Quantity : " + orderDetails.data()['foodnos'],style: TextStyle(
                        color: Color.fromARGB(
                            255, 8, 8, 8),
                        fontWeight: FontWeight.bold)),
                    Text("Current Price : " + orderDetails.data()['foodprice'],style: TextStyle(
                        color: Color.fromARGB(
                            255, 8, 8, 8),
                        fontWeight: FontWeight.bold)),
                    Text("Expiry Date : " + orderDetails.data()['expirydate'],style: TextStyle(
                        color: Color.fromARGB(
                            255, 8, 8, 8),
                        fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            Center(child: Text("Place Order",style:
            TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Column(
                children: [
                  TextFormField(
                    style: mylabelstyle,
                    controller: contactName,
                    decoration: InputDecoration(
                      hintText: 'Contact Name',
                      hintStyle: mylabelstyle,
                      labelText: 'Contact Name',
                      labelStyle: mylabelstyle,
                      enabledBorder: myenabledborder,
                      focusedBorder: myfocusedborder,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    style: mylabelstyle,
                    controller: contactNumber,
                    decoration: InputDecoration(
                      hintText: 'Contact Number',
                      hintStyle: mylabelstyle,
                      labelText: 'Contact Number',
                      labelStyle: mylabelstyle,
                      enabledBorder: myenabledborder,
                      focusedBorder: myfocusedborder,
                    ),
                  ),

                  SizedBox(height: 20),

                  TextFormField(
                    style: mylabelstyle,
                    controller: contactEmail,
                    decoration: InputDecoration(
                      hintText: 'Contact Email',
                      hintStyle: mylabelstyle,
                      labelText: 'Contact Email',
                      labelStyle: mylabelstyle,
                      enabledBorder: myenabledborder,
                      focusedBorder: myfocusedborder,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            Center(child: Text("Quantity : " + PlacedOrderDetails['orderQuantity'].toString())),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(  //To only change a few things
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 30),
                  thumbColor: Colors.deepPurple.shade600,
                  activeTrackColor: Colors.deepPurple.shade800,
                  inactiveTrackColor: Colors.deepPurple.shade300,
                  overlayColor: Colors.deepPurple.shade200
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
                  color: Colors.deepPurple.shade300,
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
                  color: Colors.deepPurple.shade300,
                ),
                SizedBox(width: 20),
                MaterialButton(
                  onPressed: ()async{
                    bool? res = await FlutterPhoneDirectCaller.callNumber(orderDetails.data()['providernumber']);
                  },
                  child: Icon(Icons.phone),
                  color: Colors.deepPurple.shade300,
                ),
              ],
            ),
            SizedBox(height: 20),
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
              height: 50,
              child: Text("Place Order"),
              color: Colors.deepPurple.shade300,
            )
          ],
        ),
      )
    );
  }
}
