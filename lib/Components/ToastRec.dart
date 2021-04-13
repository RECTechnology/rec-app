import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToastRec {
  static void printToastRec(
    BuildContext context,
    String msg,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg.toString()),
        duration: const Duration(milliseconds: 2000),
        width: 300.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
