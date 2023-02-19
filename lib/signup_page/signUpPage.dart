import 'package:firebase/login_page/loginPage.dart';
import 'package:firebase/routing/routing.dart';
import 'package:firebase/signup_page/signUpAuthorization.dart';
import 'package:flutter/material.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: username,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                TextFormField(
                  controller: emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                (signupAuth!.loading == false)?
                MaterialButton(
                    onPressed: (){
                      signupAuth.signupValidation(
                        username: username,
                        emailAddress: emailAddress,
                        password: password,
                        context: context
                      );
                    },
                  child: Text("Signup"),
                  color: Colors.red,
                ):Center(
                  child: CircularProgressIndicator(),
                ),
                GestureDetector(
                  onTap: (){
                    RoutingPage.goToNext(context: context, navigateTo: LoginPage());
                  },
                    child: Text('Login')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

