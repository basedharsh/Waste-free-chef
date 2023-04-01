import 'package:firebase/home_page/drawer.dart';
import 'package:firebase/order_display/orders_display.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home_page/homePage.dart';

class SignupAuthorization with ChangeNotifier {
  UserCredential? userCredential;
  bool loading = false;

  void signupValidation(
      {required TextEditingController? username,
      required TextEditingController? emailAddress,
      required TextEditingController? password,
      required BuildContext context}) async {
    if (username!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("User Name is Empty")));
      return;
    } else if (emailAddress!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Address is Empty")));
      return;
    } else if (password!.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Password is Empty")));
      return;
    } else {
      try {
        loading = true;
        notifyListeners();
        userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailAddress.text, password: password.text);

        loading = true;
        notifyListeners();

        FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential!.user!.uid)
            .set(
          {
            "username": username.text,
            "emailAddress": emailAddress.text,
            "password": password.text,
            "userUID": userCredential!.user!.uid
          },
        ).then((value) {
          loading = false;
          notifyListeners();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Hiddrawer(),
            ),
          );
        });
      } on FirebaseAuthException catch (e) {
        loading = false;
        notifyListeners();

        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Enter a strong Password"),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("The Email is already inuse"),
            ),
          );
        }
      }
    }
  }
}
