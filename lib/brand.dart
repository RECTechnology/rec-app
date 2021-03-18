import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rec/Entities/Account.ent.dart';

class Brand {
  static String appName = 'REC';
  static String logoUrl = 'assets/logo.jpg';
  static Color primaryColor = Color(0xfff22a47);
  static Color accentColor = Color(0xfff22a47);

  static FontStyle font = FontStyle.normal;
  static Brightness brightness = Brightness.light;

  static Color getColorForAccountType(String type) {
    return type == Account.TYPE_PRIVATE
        ? Colors.lightBlueAccent
        : Colors.orangeAccent;
  }

  static ThemeData createTheme() {
    final baseTheme = ThemeData();
    return baseTheme.copyWith(
      primaryColor: primaryColor,
      accentColor: accentColor,
      brightness: brightness,
      textTheme: baseTheme.textTheme.copyWith(
        bodyText2: baseTheme.textTheme.bodyText2.copyWith(
          color: Colors.black45,
        ),
      ),
    );
  }
}
