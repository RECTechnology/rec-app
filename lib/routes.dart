import 'package:flutter/widgets.dart';
import 'package:rec/Pages/Public/RecoveryPassword.page.dart';
import 'package:rec/Pages/Public/Register/RegisterStepOne.dart';
import 'package:rec/Pages/Public/Register/RegisterStepTwo.dart';

import 'Pages/Private/Home/Home.page.dart';
import 'Pages/Public/Login.page.dart';
import 'Components/PrivateRoute.dart';
import 'Pages/Public/PinPage.dart';

final Map<String, Widget Function(BuildContext)> ROUTES = {
  // Public routes
  '/login': (context) => LoginPage(false),
  '/recoveryPassword': (context) => RecoveryPassword(),
  '/pinPage': (context) => PinPage(),
  '/registerOne': (context) => RegisterOne(),
  '/registerTwo': (context) => RegisterTwo(),

  // Private routes
  '/home': (context) => PrivateRoute(HomePage()),
};

class InitialRoutes {
  static String home = '/home';
  static String login = '/login';

  static String getInitialRoute({bool hasToken = true}) {
    return hasToken ? InitialRoutes.home : InitialRoutes.login;
  }
}
