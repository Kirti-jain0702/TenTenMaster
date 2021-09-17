import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> showToast(String msg) async {
  await Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black.withOpacity(0.5),
      gravity: ToastGravity.TOP);
}
