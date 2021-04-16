import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/brand.dart';
import 'package:rec/preferences.dart';

class RecToast {
  static void showInfo(
    BuildContext context,
    String msg, {
    Color backgroundColor = Colors.white,
    double borderRadius = 10,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg.toString(),
          style: TextStyle(
            color: Brand.grayDark2,
            fontSize: 14,
          ),
        ),
        elevation: 4,
        backgroundColor: backgroundColor,
        duration: Preferences.toastDuration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
    BuildContext context,
    String msg,
  ) {
    return show(
      context,
      msg,
      textColor: Colors.white,
      backgroundColor: Colors.red[400],
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context,
    String msg, {
    Color textColor = Colors.white,
    Color backgroundColor = Colors.black87,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(
          msg.toString(),
          style: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        duration: Preferences.toastDuration,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        margin: EdgeInsets.only(bottom: 24, right: 32, left: 32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
