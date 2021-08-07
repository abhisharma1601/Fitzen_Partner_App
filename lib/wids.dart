import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CurrentUser {
  CurrentUser(this.uid, this.parameter);
  String uid, parameter;

  String getuid() {
    return uid;
  }

  String getpara() {
    return parameter;
  }
}

final toast = (text) => Fluttertoast.showToast(
    msg: text,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.black);

