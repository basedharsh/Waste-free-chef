import 'package:firebase/home_page/drawer.dart';
import 'package:firebase/login_page/loginAuthorization.dart';
import 'package:firebase/signup_page/signUpAuthorization.dart';
import 'package:firebase/signup_page/signUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
    
    
    MyApp());
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
          unselectedWidgetColor: Color.fromARGB(255, 227, 233, 236),
          scaffoldBackgroundColor: Colors.deepPurple.shade300,
          primarySwatch: Colors.deepPurple,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.deepPurple,
            
          ),
        ),
        debugShowMaterialGrid: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnp) {
            if (userSnp.hasData) {
              return Hiddrawer();
              // and appbar

            }
            return SignUpPage();
          },
        ),
      ),
    );
  }
}
