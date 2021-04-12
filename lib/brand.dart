import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rec/Entities/Account.ent.dart';

class Brand {
  static const String appName = 'REC';
  static const String logoUrl = 'assets/logo.jpg';
  static const Color primaryColor = Color(0xff0098DA);
  static const Color primaryColorLight = Color(0xff0C6FF0);
  static const Color accentColor = Color(0xffE05205);
  static const Color backgroundPrivateColor = Color(0xffe5f5fc);
  static const Color backgroundCompanyColor = Color(0xfffcede6);
  static const Color defectText = Color(0xff343434);

  static const Color defaultAvatarBackground = Color(0xffF2F2F2);
  static const Color separatorColor = Color(0xffE0E0E0);

  static const Color gradientPrimaryLight = Color(0xff41e4f0);
  static const Color gradientPrimaryDark = Color(0xff396ff0);

  static const Color gradientSecondaryLight = Color(0xffED9707);
  static const Color gradientSecondaryDark = Color(0xffF73807);

  // Text Colors
  static const Color grayDark = Color(0xff3B3B3B);
  static const Color grayDark2 = Color(0xff4f4f4f);
  static const Color grayLight = Color(0xff666666);

  static const Color amountNegative = Color(0xffD91636);

  static const FontStyle font = FontStyle.normal;
  static const Brightness brightness = Brightness.light;

  static LinearGradient appBarGradientPrimary = LinearGradient(
    begin: Alignment(.5, 1.3),
    end: Alignment(-.3, -0.8),
    colors: <Color>[Brand.gradientPrimaryLight, Brand.gradientPrimaryDark],
  );

  static LinearGradient appBarGradientSecondary = LinearGradient(
    begin: Alignment(.5, 1.3),
    end: Alignment(-.3, -0.8),
    colors: <Color>[Brand.gradientSecondaryLight, Brand.gradientSecondaryDark],
  );

  static LinearGradient appBarGradient = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: <Color>[primaryColor, accentColor],
    stops: [7.91, 62],
  );

  static Color getColorForAccountType(String type) {
    return type == Account.TYPE_PRIVATE ? primaryColor : accentColor;
  }

  static Color getColorForAccount(Account account) {
    return account.type == Account.TYPE_PRIVATE ? primaryColor : accentColor;
  }

  static LinearGradient getGradientForAccount(Account account) {
    return account.type == Account.TYPE_PRIVATE
        ? appBarGradientPrimary
        : appBarGradientSecondary;
  }

  static ThemeData createTheme() {
    final baseTheme = ThemeData();
    return baseTheme.copyWith(
      primaryColor: primaryColor,
      accentColor: primaryColor,
      brightness: brightness,
      dividerColor: separatorColor,
      dividerTheme: baseTheme.dividerTheme.copyWith(
        color: Brand.separatorColor,
      ),
      textTheme: baseTheme.textTheme.copyWith(
        bodyText2: baseTheme.textTheme.bodyText2.copyWith(
          color: grayDark,
        ),
        headline6: baseTheme.textTheme.headline6.copyWith(
          color: grayDark,
          fontSize: 20,
        ),
        subtitle1: baseTheme.textTheme.subtitle1.copyWith(
          color: grayDark2,
          fontSize: 16,
        ),
      ),
    );
  }
}
