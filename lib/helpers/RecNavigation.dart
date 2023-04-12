import 'package:flutter/material.dart';

class _RecNavigationWithContext {
  BuildContext context;

  _RecNavigationWithContext(this.context);

  Future<Object?> navigateToRoute<T>(String route) {
    return RecNavigation.navigateToRoute(context, route);
  }

  Future<Object?> navigate<T>(WidgetBuilder builder) {
    return RecNavigation.navigate(context, builder);
  }
}

class RecNavigation {
  static _RecNavigationWithContext of(BuildContext context) {
    return _RecNavigationWithContext(context);
  }

  static Function getNavigateToRouteCallback<T>(
    BuildContext context,
    String route,
  ) {
    return () {
      return navigateToRoute<T>(context, route);
    };
  }

  static Future<Object?> navigateToRoute<T>(BuildContext context, String route) {
    return Navigator.pushNamed<T>(context, route);
  }

  static Future<Object?> navigate<T>(
    BuildContext context,
    WidgetBuilder builder,
  ) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: builder,
      ),
    );
  }

  static Future<Object?> replace<T>(
    BuildContext context,
    WidgetBuilder builder,
  ) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: builder,
      ),
    );
  }

  static Future<Object?> replaceNamed<T>(
    BuildContext context,
    String route,
  ) {
    return Navigator.of(context).pushReplacementNamed(route);
  }
}
