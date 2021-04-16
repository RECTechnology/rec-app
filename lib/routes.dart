import 'package:flutter/widgets.dart';
import 'package:rec/Pages/Public/ForgotPassword/ForgotPassword.dart';
import 'package:rec/Pages/Public/Register/RegisterStepOne.dart';
import 'package:rec/Pages/Public/Register/RegisterStepTwo.dart';

import 'Pages/Private/Home/Home.page.dart';
import 'Pages/Public/Login/Login.page.dart';
import 'Components/PrivateRoute.dart';
import 'Pages/Public/PinPage/PinPage.dart';
import 'Pages/Public/ValidateSms/ValidateSms.dart';
import 'Pages/Public/ChangePassword/ChangePasswordPage.dart';

class Routes {
  // Public routes
  static String login = '/login';
  static String pinPage = '/pinPage';
  static String registerOne = '/registerOne';
  static String registerTwo = '/registerTwo';
  static String forgotPassword = '/forgotPassword';
  static String validateSms = '/validateSms';
  static String changePassword = '/changePassword';

  // Private routes
  static String home = '/home';

  static String getInitialRoute({bool hasToken = true}) {
    return hasToken ? Routes.home : Routes.login;
  }
}

final Map<String, Widget Function(BuildContext)> ROUTES = {
  Routes.login: (context) => LoginPage(),
  Routes.forgotPassword: (context) => ForgotPassword(),
  Routes.pinPage: (context) => PinPage(),
  Routes.registerOne: (context) => RegisterOne(),
  Routes.registerTwo: (context) => RegisterTwo(),
  Routes.validateSms: (context) => ValidateSms(),
  Routes.changePassword: (context) => ChangePasswordPage(),
  Routes.home: (context) => PrivateRoute(HomePage()),
};
