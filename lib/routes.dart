import 'package:flutter/widgets.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/charge/Charge.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/PayContactOrAccount.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/PayWithQR.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/AddNewCard.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/Recharge.page.dart';
import 'package:rec/Pages/Public/Register/RegisterStepOne.dart';

import 'Pages/Private/Home/Home.page.dart';
import 'Pages/Public/Login/Login.page.dart';
import 'Components/PrivateRoute.dart';

class Routes {
  // Public routes
  static String login = '/login';
  static String register = '/register';
  static String forgotPassword = '/forgot-password';
  static String changePassword = '/change-password';

  // Walet routes
  static String payQr = '/pay-qr';
  static String payContactAccount = '/pay-contact-account';
  static String recharge = '/recharge';
  static String charge = '/charge';

  // Route for deeplink recharge result
  static String rechargeResult = '/recharge-result';
  static String payLink = '/pay';

  static String home = '/home';
  static String newCard = '/new-card';

  static String getInitialRoute({bool hasToken = true}) {
    return hasToken ? Routes.home : Routes.login;
  }
}

final Map<String, Widget Function(BuildContext)> ROUTES = {
  Routes.login: (context) => LoginPage(),
  Routes.register: (context) => RegisterOne(),
  Routes.home: (context) => PrivateRoute(HomePage()),
  Routes.recharge: (context) => RechargePage(),
  Routes.newCard: (context) => AddNewCard(),
  Routes.payQr: (context) => PayWithQR(),
  Routes.payContactAccount: (context) => PayContactOrAccount(),
  Routes.charge: (context) => ChargePage(),
  Routes.payLink: (context) => PayContactOrAccount(),
};
