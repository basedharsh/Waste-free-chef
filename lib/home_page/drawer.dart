import 'package:firebase/chat_page/chatBot.dart';
import 'package:firebase/order_display/orders_display.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class Hiddrawer extends StatefulWidget {
  const Hiddrawer({super.key});

  @override
  State<Hiddrawer> createState() => _HiddrawerState();
}

class _HiddrawerState extends State<Hiddrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Main Page",
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        OrdersDisplay(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Chatbot",
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        Chatbotsupport(),
      ),
    ];
  }

  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.deepPurple,
      screens: _pages,
      initPositionSelected: 0,
    );
  }
}
