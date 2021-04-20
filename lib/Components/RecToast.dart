import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/preferences.dart';

class RecToast {
  static void show(
    BuildContext context,
    String msg, {
    Color textColor = Colors.white,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // backgroundColor: Colors.white,
        content: Text(
          msg.toString(),
          style: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
        ),
        duration: Preferences.toastDuration,
        width: 300.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
