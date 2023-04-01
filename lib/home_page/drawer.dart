import 'package:firebase/chat_page/chatBot.dart';
import 'package:firebase/map_page/mapPage.dart';
import 'package:firebase/order_display/orders_display.dart';
import 'package:firebase/order_form/food_details_form.dart';
import 'package:firebase/past_orders/past_orders.dart';
import 'package:firebase/signup_page/signUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class Hiddrawer extends StatefulWidget {
  const Hiddrawer({super.key});

  @override
  State<Hiddrawer> createState() => _HiddrawerState();
}

class _HiddrawerState extends State<Hiddrawer> {
  List<ScreenHiddenDrawer> _pages = [];

// This is the style for the text in the drawer menu
  final myTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: "Home Page",
            baseStyle: myTextStyle,
            selectedStyle: myTextStyle,
            colorLineSelected: Colors.deepPurple),
        OrdersDisplay(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: "Chatbot",
            baseStyle: myTextStyle,
            selectedStyle: myTextStyle,
            colorLineSelected: Colors.deepPurple),
        Chatbotsupport(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: "Map Page",
            baseStyle: myTextStyle,
            selectedStyle: myTextStyle,
            colorLineSelected: Colors.deepPurple),
        MapPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: "Place Order",
            baseStyle: myTextStyle,
            selectedStyle: myTextStyle,
            colorLineSelected: Colors.deepPurple),
        OrderDetails(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: "Past Orders",
            baseStyle: myTextStyle,
            selectedStyle: myTextStyle,
            colorLineSelected: Colors.deepPurple),
        PastOrders(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpPage())));
            },
            name: "Sign Out",
            baseStyle: myTextStyle,
            selectedStyle: myTextStyle,
            colorLineSelected: Colors.deepPurple),
        SignUpPage(),
      ),
    ];
  }

  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Color.fromARGB(255, 163, 139, 209),
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 40,
      contentCornerRadius: 15,
      boxShadow: [
        BoxShadow(
          blurRadius: 10,
          spreadRadius: 5,
          color: Colors.black.withOpacity(0.5),
        ),
      ],
    );
  }
}
