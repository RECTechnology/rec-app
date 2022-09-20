import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/preferences.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RecToast {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showInfo(
    BuildContext context,
    String msg, {
    Color? backgroundColor,
    Color color = Colors.white,
    double borderRadius = 10,
  }) {
    final recTheme = RecTheme.of(context);

    return show(
      context,
      msg,
      textColor: Colors.white,
      backgroundColor: backgroundColor ?? recTheme?.primaryColor,
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
      Checks.isNotEmpty(msg) ? msg : 'UNEXPECTED_SERVER_ERROR',
      textColor: Colors.white,
      backgroundColor: Colors.red[400],
    );
  }

  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show(
    BuildContext context,
    String msg, {
    Color textColor = Colors.white,
    Color? backgroundColor = Colors.black87,
    double elevation = 1,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LocalizedText(
              msg.toString(),
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
        elevation: elevation,
      ),
    );
  }
}
