import 'package:flutter/widgets.dart';
import 'package:rec/Pages/Public/RecoveryPassword.page.dart';

import 'Pages/Private/Home/Home.page.dart';
import 'Pages/Public/Login.page.dart';
import 'Components/PrivateRoute.dart';

// ignore: non_constant_identifier_names
final Map<String, Widget Function(BuildContext)> ROUTES = {
  '/login': (context) => LoginPage(false),
  '/recoveryPassword': (context) => RecoveryPassword(),
  '/home': (context) => PrivateRoute(HomePage()),
};

class InitialRoutes {
  static String loggedIn = '/home';
  static String notLoggedIn = '/login';

  static String getInitialRoute({bool hasToken = false}) {
    return hasToken ? InitialRoutes.loggedIn : InitialRoutes.notLoggedIn;
  }
}
