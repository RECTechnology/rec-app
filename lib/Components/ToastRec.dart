import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToastRec {


   void printToastRec(String msg,BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(

        content: Text(msg.toString()),
        duration: const Duration(milliseconds: 2000),
        width: 300.0,
        // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }


}