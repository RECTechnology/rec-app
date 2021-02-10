import 'package:flutter/widgets.dart';

import 'Pages/Private/Home/Home.page.dart';
import 'Pages/Public/Login.page.dart';
import 'Widgets/PrivateRoute.dart';

// ignore: non_constant_identifier_names
final Map<String, Widget Function(BuildContext)> ROUTES = {
  '/login': (context) => LoginPage(),
  '/home': (context) => PrivateRoute(HomePage()),
};

class InitialRoutes {
  static String loggedIn = '/login';
  static String notLoggedIn = '/home';

  static String getInitialRoute({bool hasToken = false}) {
    return hasToken ? InitialRoutes.loggedIn : InitialRoutes.notLoggedIn;
  }
}
