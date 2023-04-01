import 'package:firebase/login_page/loginAuthorization.dart';
import 'package:firebase/order_display/orders_display.dart';
import 'package:firebase/signup_page/signUpAuthorization.dart';
import 'package:firebase/signup_page/signUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'home_page/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignupAuthorization(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginAuthorization(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 255, 0, 0),
        ),
        debugShowMaterialGrid: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnp) {
            if (userSnp.hasData) {
              return OrdersDisplay();
              // and appbar
              
            }
            return SignUpPage();
          },
        ),
      ),
    );
  }
}
