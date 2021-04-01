import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rec/Entities/Account.ent.dart';

class Brand {
  static String appName = 'REC';
  static String logoUrl = 'assets/logo.jpg';
  static Color primaryColor = Color(0xff0098DA);
  static Color accentColor = Color(0xffE05205);
  static Color backgroundPrivateColor = Color(0xffe5f5fc);
  static Color backgroundCompanyColor = Color(0xfffcede6);
  static FontStyle font = FontStyle.normal;
  static Brightness brightness = Brightness.light;

  static Color getColorForAccountType(String type) {
    return type == Account.TYPE_PRIVATE ? primaryColor : accentColor;
  }

  static ThemeData createTheme() {
    final baseTheme = ThemeData();
    return baseTheme.copyWith(
      primaryColor: primaryColor,
      accentColor: accentColor,
      brightness: brightness,
      textTheme: baseTheme.textTheme.copyWith(
        bodyText2: baseTheme.textTheme.bodyText2.copyWith(
          color: Color(0xff3B3B3B),
        ),
        headline6: baseTheme.textTheme.headline6.copyWith(
          color: Color(0xff3B3B3B),
        ),
      ),
    );
  }
}
