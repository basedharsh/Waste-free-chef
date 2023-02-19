import 'package:firebase/login_page/loginPage.dart';
import 'package:firebase/routing/routing.dart';
import 'package:firebase/signup_page/signUpAuthorization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

TextEditingController username = TextEditingController();
TextEditingController emailAddress = TextEditingController();
TextEditingController password = TextEditingController();

bool changeButton = false;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
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
    SignupAuthorization signupAuth = Provider.of<SignupAuthorization>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Container(
                  height: 120,
                  width: 120,
                  child: Image.asset(
                    'images/wasted1.gif',
                    height: 200,
                    width: 200,
                  ),
                ),
                Text(
                  "Waste-food-Chef",
                  style: GoogleFonts.lobster(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 5, 237, 125),
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Welcome to Waste-food-Chef",
                  style: GoogleFonts.autourOne(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 177, 124, 242),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  style: TextStyle(
                    color: Color.fromARGB(255, 227, 233, 236),
                  ),
                  controller: username,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                      // align the text to the left instead of centered
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 139, 13, 236),
                    ),
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 249, 241, 255),
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(
                    color: Color.fromARGB(255, 227, 233, 236),
                  ),
                  controller: emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                      // align the text to the left instead of centered
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 139, 13, 236),
                    ),
                    labelText: 'Email Address',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 230, 230, 230),
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(
                    color: Color.fromARGB(255, 227, 233, 236),
                  ),
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                      // align the text to the left instead of centered
                    ),
                    prefixIcon: Icon(
                      Icons.remove_red_eye,
                      color: Color.fromARGB(255, 139, 13, 236),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 249, 241, 255),
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                (signupAuth!.loading == false)
                    ? MaterialButton(
                        onPressed: () {
                          signupAuth.signupValidation(
                              username: username,
                              emailAddress: emailAddress,
                              password: password,
                              context: context);
                        },
                        hoverColor: Color.fromARGB(255, 195, 66, 30),
                        child: Text("Signup"),
                        color: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 139, 13, 236),
                        fontSize: 20,
                        // align the text to the left instead of centered
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        RoutingPage.goToNext(
                            context: context, navigateTo: LoginPage());
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Color.fromARGB(255, 5, 237, 125),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // align the text to the left instead of centered
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),
                Text(
                  "CopyRight@2023",
                  style: TextStyle(
                      color: Color.fromARGB(255, 56, 58, 58),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}