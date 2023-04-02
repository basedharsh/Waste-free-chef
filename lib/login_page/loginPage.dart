import 'package:firebase/signup_page/signUpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

import '../routing/routing.dart';
import 'loginAuthorization.dart';

TextEditingController emailAddress = TextEditingController();
TextEditingController password = TextEditingController();

bool changeButton = false;

// Now login page using Rive animation

// Main Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        unselectedWidgetColor: Color.fromARGB(255, 227, 233, 236),
        scaffoldBackgroundColor: Colors.deepPurple.shade300,
        primarySwatch: Colors.deepPurple,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
        ),
      ),
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
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  //on screen tap keyboard will be closed funxtion
  void _requestKeyboardClose() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    LoginAuthorization loginAuth = Provider.of<LoginAuthorization>(context);
    // MediaQuery for responsive design
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        //on screen tap keyboard will be closed
        child: GestureDetector(
          onTap: () {
            _requestKeyboardClose();
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  "Waste-food-Chef",
                  style: GoogleFonts.lobster(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Welcome to Waste-food-Chef",
                  style: GoogleFonts.autourOne(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 206, 7, 0),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                // artboard for animation here

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 0.3 * size.height,
                  //write width using MediaQuery
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: 0.6 * size.width,
                  child: RiveAnimation.asset(
                    "images/login.riv",
                    // height of animation
                    fit: BoxFit.fill,

                    //ROund corners of animation
                    alignment: Alignment.topCenter,
                    stateMachines: const ["Login Machine"],
                    onInit: (artboard) {
                      controller = StateMachineController.fromArtboard(
                          artboard, "Login Machine");
                      if (controller == null) return;

                      artboard.addController(controller!);
                      isChecking = controller?.findInput("isChecking");
                      isHandsUp = controller?.findInput("isHandsUp");
                      trigSuccess = controller?.findInput("trigSuccess");
                      trigFail = controller?.findInput("trigFail");
                    },
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  // padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(left: 20, right: 20),
                  width: 0.96 * size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      SizedBox(height: 30),
                      //For Email
                      TextFormField(
                        controller: emailAddress,
                        onChanged: ((value) {
                          if (isHandsUp != null) {
                            isHandsUp!.change(false);
                          }
                          if (isChecking == null) return;

                          isChecking!.change(true);
                        }),
                        decoration: InputDecoration(
                          //label text and style
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.blueGrey,
                          ),
                          // Icon for email
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),

                          hintText: 'Email',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                            //thickness: 5,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      // For Password
                      TextFormField(
                        onChanged: ((value) {
                          if (isChecking != null) {
                            isChecking!.change(false);
                          }
                          if (isHandsUp == null) return;

                          isHandsUp!.change(true);
                        }),
                        controller: password,
                        obscureText: true,
                        //Password decoration
                        decoration: InputDecoration(
                          //label text and style
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.blueGrey,
                          ),
                          // Icon for email
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),

                          hintText: 'Password',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 0, 0, 0),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                            //thickness: 5,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      (loginAuth.loading == false)
                          ? MaterialButton(
                              onPressed: () {
                                //Login button on pressed validation
                                loginAuth.loginValidation(
                                    emailAddress: emailAddress,
                                    password: password,
                                    context: context);
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              color: Color.fromARGB(255, 0, 0, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 15,
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
                                      color: Color.fromARGB(255, 206, 7, 0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Text("Forgot Password?",
                      //     style: TextStyle(
                      //         color: Color.fromARGB(255, 210, 152, 255),
                      //         fontSize: 15,
                      //         fontWeight: FontWeight.bold)),
                      // SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:firebase/login_page/loginAuthorization.dart';
// import 'package:firebase/signup_page/signUpPage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:rive/rive.dart';

// TextEditingController emailAddress = TextEditingController();
// TextEditingController password = TextEditingController();

// bool changeButton = false;

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   StateMachineController? controller;

//   SMIInput<bool>? isChecking;
//   SMIInput<bool>? isHandsUp;
//   SMIInput<bool>? trigSuccess;
//   SMIInput<bool>? trigFail;
// //
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     LoginAuthorization loginAuth = Provider.of<LoginAuthorization>(context);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SizedBox(
//         width: size.width,
//         height: size.height,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               //rive animation
//               SizedBox(
//                 width: size.width,
//                 height: 200,
//                 child: RiveAnimation.asset(
//                   "images/login.riv",
//                   stateMachines: const ["Login Machine"],
//                   onInit: (artboard) {
//                     controller = StateMachineController.fromArtboard(
//                         artboard, "Login Machine");
//                     if (controller == null) return;

//                     artboard.addController(controller!);
//                     isChecking = controller?.findInput("isChecking");
//                     isHandsUp = controller?.findInput("isHandsUp");
//                     trigSuccess = controller?.findInput("trigSuccess");
//                     trigFail = controller?.findInput("trigFail");
//                   },
//                 ),
//               ),

//               const SizedBox(height: 10),
//               TextField(
//                 onChanged: (value) {
//                   if (isHandsUp != null) {
//                     isHandsUp!.change(false);
//                   }
//                   if (isChecking == null) return;

//                   isChecking!.change(true);
//                 },
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   hintText: "E mail",
//                   prefixIcon: const Icon(Icons.mail),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 onChanged: (value) {
//                   if (isChecking != null) {
//                     isChecking!.change(false);
//                   }
//                   if (isHandsUp == null) return;

//                   isHandsUp!.change(true);
//                 },
//                 obscureText: true, // to hide password
//                 decoration: InputDecoration(
//                   hintText: "Password",
//                   prefixIcon: const Icon(Icons.lock),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),

//               SizedBox(
//                 width: size.width,
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SignUpPage(),
//                           ));
//                     },
//                     child: const Text(
//                       "Forgot your password?",
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                           decoration: TextDecoration.underline,
//                           color: Colors.black),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               (loginAuth.loading == false)
//                   ? MaterialButton(
//                       minWidth: size.width,
//                       height: 50,
//                       color: Colors.purple,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       onPressed: () {
//                         // todo login
//                         //Login button on pressed validation
//                         loginAuth.loginValidation(
//                             emailAddress: emailAddress,
//                             password: password,
//                             context: context);
//                       },
//                       child: const Text(
//                         "Login",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   : CircularProgressIndicator(),
//               const SizedBox(height: 10),
//               SizedBox(
//                 width: size.width,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Don't you have an account?"),
//                     TextButton(
//                       onPressed: () {
//                         // todo register
//                       },
//                       child: const Text(
//                         "Register",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
