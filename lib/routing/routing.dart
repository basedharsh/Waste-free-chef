import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoutingPage{
  static goToNext({required BuildContext context, required Widget navigateTo}){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>navigateTo)
    );
  }
}