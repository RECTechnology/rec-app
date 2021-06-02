import 'package:flutter/material.dart';

class RecNavigation {
  static Function getNavigateToRouteCallback(
    BuildContext context,
    String route,
  ) {
    return () {
      return navigateToRoute(context, route);
    };
  }

  static Future<Object> navigateToRoute(BuildContext context, String route) {
    return Navigator.pushNamed(context, route);
  }
}
