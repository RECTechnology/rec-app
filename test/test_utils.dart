import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';

class TestUtils {
  static Widget wrapPrivateRoute(Widget page) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppState(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserState(RecStorage(), null),
        )
      ],
      child: wrapInMaterialApp(page),
    );
  }

  static Widget wrapPublicRoute(Widget page) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: wrapInMaterialApp(page),
    );
  }

  static MaterialApp wrapInMaterialApp(Widget widget) {
    return MaterialApp(
      home: Scaffold(
        body: Localizations(
          delegates: [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            AppLocalizations.delegate
          ],
          locale: Locale('es'),
          child: widget,
        ),
      ),
    );
  }

  /// Expects a widget to exists, from a widget instance
  /// `widgetExistsByWidget(widget)`
  static void widgetExistsByWidget(Widget page) {
    expect(find.byWidget(page), findsOneWidget);
  }

  /// Expects a widget to exists, from a widget Type
  /// `widgetExistsByType(Text)`
  static void widgetExistsByType(Type page) {
    expect(find.byType(page), findsOneWidget);
  }

  /// Expects a widget to exists, from a widget Type
  /// `widgetExistsByType('text')`
  static void isTextPresent(String text) {
    expect(find.text(text), findsOneWidget);
  }
}
