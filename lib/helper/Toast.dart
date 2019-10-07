import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MToast {
  static show(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.white54,
      textColor: Colors.black,
      fontSize: 16,
    );
  }
}