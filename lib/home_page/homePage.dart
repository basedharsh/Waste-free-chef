// //USELESS CODE FOR NOW Maybe later
// //
// //
// //
// //
// //
// //
// ///
// ////
// ////
// ////
// ////
// ////
// ////
// ////

// import 'package:firebase/chat_page/chatBot.dart';
// import 'package:firebase/home_page/drawer.dart';
// import 'package:firebase/order_form/food_details_form.dart';
// import 'package:firebase/map_page/mapPage.dart';
// import 'package:firebase/order_display/orders_display.dart';
// import 'package:firebase/past_orders/past_orders.dart';
// import 'package:firebase/signup_page/signUpPage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// int selectedIndex = 0;

// List<Widget> myPages = [
//   OrdersDisplay(),
//   OrderDetails(),
//   PastOrders(),
//   MapPage(),
//   Chatbotsupport()
// ];

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyApp(),
//     );
//   }
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,

//         // leading: IconButton(
//         //   onPressed: () {
//         //     Navigator.push(
//         //       context,
//         //       MaterialPageRoute(builder: (context) => Hiddrawer()),
//         //     );
//         //   },
//         //   icon: Icon(Icons.menu),
//         //   color: Colors.black,
//         // ),
//         title: Text(
//           'WFC',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 25,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.grey.shade200,
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: Icon(Icons.keyboard_double_arrow_left_rounded),
//             alignment: Alignment.centerLeft,
//             color: Colors.black,
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: Icon(Icons.person),
//             alignment: Alignment.centerRight,
//             color: Colors.black,
//           ),
//           IconButton(
//             alignment: Alignment.centerLeft,
//             // Go back to last page
//             onPressed: () {
//               // Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back),
//             color: Colors.black,
//           ),
//           IconButton(
//             onPressed: () {
//               FirebaseAuth.instance.signOut().then((value) =>
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => SignUpPage())));
//             },
//             icon: Icon(Icons.exit_to_app),
//             color: Colors.black,
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               child: Text('WFC'),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//             ),
//             ListTile(
//               title: Text('Main Page'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => OrdersDisplay()),
//                 );
//               },
//             ),
//             ListTile(
//               title: Text('Chatbot'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Chatbotsupport()),
//                 );
//               },
//             ),
//             ListTile(
//               title: Text('Past Orders'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => PastOrders()),
//                 );
//               },
//             ),
//             ListTile(
//               title: Text('Map'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => MapPage()),
//                 );
//               },
//             ),
//             // Donate
//             ListTile(
//               title: Text('Donate'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => OrderDetails()),
//                 );
//               },
//             ),
//             ListTile(
//               title: Text('Sign Out'),
//               onTap: () {
//                 FirebaseAuth.instance.signOut().then((value) =>
//                     Navigator.of(context).push(
//                         MaterialPageRoute(builder: (context) => SignUpPage())));
//               },
//             ),
//           ],
//         ),
//       ),
//       // bottomNavigationBar: BottomNavigationBar(
//       //   items: const <BottomNavigationBarItem>[
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.home),
//       //       label: 'Home',
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.payment),
//       //       label: 'Donate',
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.shopping_cart),
//       //       label: 'Past',
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.map),
//       //       label: 'Map',
//       //     ),
//       //     BottomNavigationBarItem(
//       //       icon: Icon(Icons.chat),
//       //       label: 'Chat',
//       //     ),
//       //   ],
//       //   currentIndex: selectedIndex,
//       //   unselectedItemColor: Colors.grey,
//       //   selectedItemColor: Color.fromARGB(255, 0, 0, 0),
//       //   onTap: (index) {
//       //     setState(() {
//       //       selectedIndex = index;
//       //     });
//       //   },
//       //   //backgroundColor: Color.fromARGB(255, 139, 13, 236),
//       // ),
//       // body: myPages[selectedIndex],
//     );
//   }
// }
