import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/CampaignProvider.dart';
import 'package:rec/Providers/DocumentsProvider.dart';
import 'package:rec/Providers/PreferenceProvider.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';

import 'mocks/services_mock.dart';

class TestUtils {
  static Widget wrapPrivateRoute(
    Widget page, {
    UserState state,
    TransactionProvider transactionProvider,
    DocumentsProvider documentsProvider,
    CampaignProvider campaignsProvider,
    PreferenceProvider preferenceProvider,
    List<SingleChildWidget> providers = const [],
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppState(
            packageInfo: PackageInfo(
              appName: 'rec',
              packageName: 'com.barcelona.rec',
              version: '2.0.0',
              buildNumber: '8',
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => state ?? UserState(RecSecureStorage(), null),
        ),
        ChangeNotifierProvider(
          create: (context) => documentsProvider ?? DocumentsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              campaignsProvider ??
              CampaignProvider(
                service: ServicesMock.campaignService,
              ),
        ),
        ChangeNotifierProvider(
          create: (context) => documentsProvider ?? DocumentsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => preferenceProvider ?? PreferenceProvider(),
        ),
        ...providers
      ],
      child: wrapInMaterialApp(page),
    );
  }

  static Widget wrapPublicRoute(Widget page, {Key key}) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: wrapInMaterialApp(page, key: key),
    );
  }

  static Widget wrapPublicWidget(Widget page) {
    return wrapPublicRoute(page);
  }

  static MaterialApp wrapInMaterialApp(Widget widget, {Key key}) {
    return MaterialApp(
      navigatorKey: key,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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

  static String richTextToPlainText(final Widget widget) {
    if (widget is RichText) {
      if (widget.text is TextSpan) {
        final buffer = StringBuffer();
        (widget.text as TextSpan).computeToPlainText(buffer);
        return buffer.toString();
      }
    }
    return null;
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

  static void isRichTextPresent(String text) {
    expect(
      find.byWidgetPredicate(
        (widget) => richTextToPlainText(widget) == text,
      ),
      findsOneWidget,
    );
  }
}
