import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';

class TestUtils {
  static Widget wrapPrivateRoute(
    Widget page, {
    UserState state,
    TransactionProvider transactionProvider,
    List<SingleChildWidget> providers = const [],
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppState(),
        ),
        ChangeNotifierProvider(
          create: (context) => state ?? UserState(RecStorage(), null),
        ),
        ...providers
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

  static Widget wrapPublicWidget(Widget page) {
    return wrapPublicRoute(page);
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
  static void widgetExists(Widget page) {
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
