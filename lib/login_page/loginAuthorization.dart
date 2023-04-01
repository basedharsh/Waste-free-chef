import 'package:firebase/home_page/homePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginAuthorization with ChangeNotifier {
  UserCredential? userCredential;
  bool loading = false;

  void loginValidation(
      {required TextEditingController? emailAddress,
      required TextEditingController? password,
      required BuildContext context}) async {
    if (emailAddress!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Address is Empty")));
      return;
    } else if (password!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password is Empty")));
      return;
    } else if (emailAddress.text.trim() == 'admin1@gmail.com' &&
        password.text.trim() == 'admin1pass') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
      return;
    } else {
      try {
        loading = true;
        notifyListeners();

        userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailAddress.text, password: password.text)
            .then((value) async {
          loading = false;
          notifyListeners();
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomePage()));
        });
      } on FirebaseAuthException catch (e) {
        loading = false;
        notifyListeners();

        if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("User Not Found")));
        } else if (e.code == "wrong-password") {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Wrong Password")));
        }
      }
    }
  }
}
