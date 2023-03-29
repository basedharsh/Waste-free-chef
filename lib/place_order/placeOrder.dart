import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String chatLink = "https://wa.me/918779618833?text=Hyyy";

final PlacedOrderDetails = <String, dynamic>{
  "providerId": "",
  "customerId": "",
  "orderId": "",
  "orderQuantity": 1,
  "orderPrice": 0,
  "apporived": false,
  "status": "onHold"
};

final db = FirebaseFirestore.instance;

//String customerId = "";
//String providerId = "";
//String orderId = "";
var orderDetails;

//int orderQuantity = 1;
//int orderPrice = 0;

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
                      print(quantity);
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
                    onPressed: (){

                    },
                    child: Icon(Icons.call),
                    color: Colors.pink,
                  ),
                ],
              ),

              MaterialButton(
                  onPressed: (){
                    db
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
