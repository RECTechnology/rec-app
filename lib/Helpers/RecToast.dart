import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';
import 'package:rec/preferences.dart';

class RecToast {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfo(
    BuildContext context,
    String msg, {
    Color backgroundColor = Brand.primaryColor,
    Color color = Colors.white,
    double borderRadius = 10,
  }) {
    return show(
      context,
      msg,
      textColor: Colors.white,
      backgroundColor: Brand.primaryColor,
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccess(
    BuildContext context,
    String msg, {
    double borderRadius = 10,
  }) {
    return show(
      context,
      msg,
      textColor: Colors.white,
      backgroundColor: Colors.green[400],
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
    var localizations = AppLocalizations.of(context);

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              localizations.translate(msg.toString()),
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        duration: Preferences.toastDuration,
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
