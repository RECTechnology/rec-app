
import 'package:flutter/widgets.dart';
import 'package:rec/Pages/Public/RecoveryPassword.page.dart';
import 'package:rec/Pages/Public/Register/RegisterStepOne.dart';
import 'package:rec/Pages/Public/Register/RegisterStepTwo.dart';

import 'Pages/Private/Home/Home.page.dart';
import 'Pages/Public/Login.page.dart';
import 'Components/PrivateRoute.dart';
import 'Pages/Public/PinPage.dart';

// ignore: non_constant_identifier_names
final Map<String, Widget Function(BuildContext)> ROUTES = {
  '/login': (context) => LoginPage(false),
  '/recoveryPassword': (context) => RecoveryPassword(),
  '/pinPage':(context) => PinPage(),
  '/home': (context) => PrivateRoute(HomePage()),
  '/registerOne':(context) => RegisterOne(),
  '/registerTwo':(context) => RegisterTwo(),
};

class InitialRoutes {
  static String loggedIn = '/login';
  static String notLoggedIn = '/home';

  static String getInitialRoute({bool hasToken = true}) {
    return hasToken ? InitialRoutes.loggedIn : InitialRoutes.notLoggedIn;
  }
}
