import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Styles/TextStyles.dart';

class Brand {
  static const String appName = 'REC';
  static const String logoUrl = 'assets/logo.jpg';

  static const Color primaryColor = Color(0xff0098DA);
  static const Color primaryColorLight = Color(0xff0C6FF0);
  static const Color accentColor = Color(0xffE05205);
  static const Color backgroundPrivateColor = Color(0xffe5f5fc);
  static const Color backgroundCompanyColor = Color(0xfffcede6);
  static const Color defectText = Color(0xff343434);
  static const Color green = Color(0xff21EB00);

  static const Color defaultAvatarBackground = Color(0xffF2F2F2);
  static const Color separatorColor = Color(0xffE0E0E0);

  static const Color gradientPrimaryLight = Color(0xff41e4f0);
  static const Color gradientPrimaryDark = Color(0xff396ff0);

  static const Color gradientSecondaryLight = Color(0xffED9707);
  static const Color gradientSecondaryDark = Color(0xffF73807);

  // Text Colors
  static const Color grayDark = Color(0xff3B3B3B);
  static const Color grayDark2 = Color(0xff4f4f4f);
  static const Color grayDark3 = Color(0xff808080);

  static const Color grayLight = Color(0xff666666);
  static const Color grayLight2 = Color(0xffBDBDBD);
  static const Color grayIcon = Color(0xffBFBFBF);

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
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: baseTheme.appBarTheme.copyWith(elevation: 0),
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

  static void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.ring
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..backgroundColor = Colors.white.withAlpha(0)
      ..indicatorColor = Brand.primaryColor
      ..textColor = Brand.primaryColor
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = Colors.white.withOpacity(0.8)
      ..textStyle = TextStyles.pageTitle
      ..userInteractions = true
      ..dismissOnTap = false;
  }
}
