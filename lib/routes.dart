import 'package:flutter/widgets.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/AddNewCard.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/Recharge.page.dart';
import 'package:rec/Pages/Private/Shared/CreatePin.page.dart';
import 'package:rec/Pages/Private/Shared/EnterPin.page.dart';
import 'package:rec/Pages/Public/ForgotPassword/ForgotPassword.dart';
import 'package:rec/Pages/Public/Register/RegisterStepOne.dart';

import 'Pages/Private/Home/Home.page.dart';
import 'Pages/Public/Login/Login.page.dart';
import 'Components/PrivateRoute.dart';
import 'Pages/Public/ChangePassword/ChangePasswordPage.dart';

class Routes {
  // Public routes
  static String login = '/login';
  static String register = '/register';
  static String forgotPassword = '/forgotPassword';
  static String changePassword = '/changePassword';
  static String recharge = '/recharge';

  // Private routes
  static String home = '/home';
  static String newCard = '/newCard';
  static String enterPin = '/enterPin';
  static String createPin = '/createPin';

  static String getInitialRoute({bool hasToken = true}) {
    return hasToken ? Routes.home : Routes.login;
  }
}

final Map<String, Widget Function(BuildContext)> ROUTES = {
  Routes.login: (context) => LoginPage(),
  Routes.forgotPassword: (context) => ForgotPassword(),
  Routes.register: (context) => RegisterOne(),
  Routes.changePassword: (context) => ChangePasswordPage(),
  Routes.home: (context) => PrivateRoute(HomePage()),
  Routes.recharge: (context) => RechargePage(),
  Routes.newCard: (context) => AddNewCard(),
  Routes.enterPin: (context) => EnterPin(),
  Routes.createPin: (context) => CreatePin(),
};
