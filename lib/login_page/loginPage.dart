import 'package:firebase/signup_page/signUpPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../routing/routing.dart';
import 'loginAuthorization.dart';

TextEditingController emailAddress = TextEditingController();
TextEditingController password = TextEditingController();

bool changeButton = false;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    LoginAuthorization loginAuth = Provider.of<LoginAuthorization>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 6, 6),
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
                  "Waste-free-Chef",
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
                  "Welcome-Back",
                  style: GoogleFonts.autourOne(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 177, 124, 242),
                      fontSize: 18,
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
                  controller: emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                      // align the text to the left instead of centered
                    ),
                    labelText: 'Email Address',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                    ),
                    prefixIcon: Icon(
                      Icons.email,
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
                (loginAuth.loading == false)
                    ? MaterialButton(
                        onPressed: () {
                          loginAuth.loginValidation(
                              emailAddress: emailAddress,
                              password: password,
                              context: context);
                        },
                        child: Text("Login"),
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
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 139, 13, 236),
                        fontSize: 20,
                        // align the text to the left instead of centered
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          RoutingPage.goToNext(
                              context: context, navigateTo: SignUpPage());
                        },
                        child: Text(' Signup',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
                SizedBox(height: 30),
                Text("Forgot Password?",
                    style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 100),
                Text(
                  "CopyRight@2023",
                  style: TextStyle(
                      color: Color.fromARGB(255, 59, 61, 61),
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
