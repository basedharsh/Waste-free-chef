import 'package:firebase/login_page/loginPage.dart';
import 'package:firebase/routing/routing.dart';
import 'package:firebase/signup_page/signUpAuthorization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

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
    SignupAuthorization signupAuth = Provider.of<SignupAuthorization>(context);
    // media query
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            _requestKeyboardClose();
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  // Container(
                  //   height: 120,
                  //   width: 120,
                  //   child: Image.asset(
                  //     'images/wasted1.gif',
                  //     height: 200,
                  //     width: 200,
                  //   ),
                  // ),
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
                  SizedBox(height: 10),
                  Text(
                    "Welcome to Waste-food-Chef",
                    style: GoogleFonts.autourOne(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 177, 124, 242),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
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
                  SizedBox(height: 00),

                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(children: [
                      SizedBox(height: 30),
                      TextFormField(
                        controller: username,
                        onChanged: ((value) {
                          if (isHandsUp != null) {
                            isHandsUp!.change(false);
                          }
                          if (isChecking == null) return;

                          isChecking!.change(true);
                        }),
                        decoration: InputDecoration(
                          //label text and style
                          labelText: 'Username',
                          labelStyle: TextStyle(
                            color: Color.fromARGB(255, 139, 13, 236),
                          ),
                          // Icon for email
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 139, 13, 236),
                          ),

                          hintText: 'Username',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 154, 120, 255),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                            //thickness: 5,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(158, 136, 255, 1),
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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
                            color: Color.fromARGB(255, 139, 13, 236),
                          ),
                          // Icon for email
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color.fromARGB(255, 139, 13, 236),
                          ),

                          hintText: 'Email',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 154, 120, 255),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                            //thickness: 5,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(158, 136, 255, 1),
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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
                            color: Color.fromARGB(255, 139, 13, 236),
                          ),
                          // Icon for email
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 139, 13, 236),
                          ),

                          hintText: 'Password',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 154, 120, 255),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                            //thickness: 5,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(158, 136, 255, 1),
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      (signupAuth.loading == false)
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
                      SizedBox(height: 10),
                      // Text(
                      //   "CopyRight@2023",
                      //   style: TextStyle(
                      //       color: Color.fromARGB(255, 56, 58, 58),
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.bold),
                      // ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
