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
      backgroundColor: Color.fromARGB(255, 18, 17, 17),
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
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                      // align the text to the left instead of centered
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
                  controller: emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email Address',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                      // align the text to the left instead of centered
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
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 139, 13, 236),
                      // align the text to the left instead of centered
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 139, 13, 236),
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
                          fontWeight: FontWeight.bold,
                          // align the text to the left instead of centered
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
