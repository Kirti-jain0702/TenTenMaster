import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

showProgressDialog(BuildContext context) async {
  await showDialog(context: context, builder: (context) => ProgressLoader());
}
