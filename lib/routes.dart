import 'package:flutter/widgets.dart';
import 'package:rec/Pages/Public/Register/RegisterStepOne.dart';
import 'package:rec/Pages/Public/Register/RegisterStepTwo.dart';

import 'Pages/Private/Home/Home.page.dart';
import 'Pages/Public/Login/Login.page.dart';
import 'Components/PrivateRoute.dart';
import 'Pages/Public/PinPage/PinPage.dart';
import 'Pages/Public/RecoveryPassword/RecoveryPassword.page.dart';

class Routes {
  static String home = '/home';
  static String login = '/login';
  static String pinPage = '/pinPage';
  static String registerOne = '/registerOne';
  static String registerTwo = '/registerTwo';
  static String recoveryPassword = '/recoveryPassword';

  static String getInitialRoute({bool hasToken = true}) {
    return hasToken ? Routes.home : Routes.login;
  }
}

final Map<String, Widget Function(BuildContext)> ROUTES = {
  Routes.login: (context) => LoginPage(),
  Routes.recoveryPassword: (context) => RecoveryPasswordPage(),
  Routes.pinPage: (context) => PinPage(),
  Routes.registerOne: (context) => RegisterOne(),
  Routes.registerTwo: (context) => RegisterTwo(),
  Routes.home: (context) => PrivateRoute(HomePage()),
};
