import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/config/themes/rec.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/app_provider.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/documents_provider.dart';
import 'package:rec/providers/preference_provider.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/providers/campaign_manager.dart';

import 'mocks/services_mock.dart';
import 'mocks/storage_mock.dart';
import 'mocks/users_mock.dart';

class TestUtils {
  static Future<Widget> wrapPrivateRoute(
    Widget page, {
    UserState? userState,
    Locale? locale,
    TransactionProvider? transactionProvider,
    DocumentsProvider? documentsProvider,
    CampaignProvider? campaignsProvider,
    PreferenceProvider? preferenceProvider,
    CampaignManager? campaignManager,
    List<SingleChildWidget> providers = const [],
    List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
  }) async {
    await dotenv.load(fileName: "env/.env-test");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppProvider(
            packageInfo: PackageInfo(
              appName: 'rec',
              packageName: 'com.barcelona.rec',
              version: '2.0.0',
              buildNumber: '8',
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              userState ??
              UserState(
                StorageMock(),
                null,
                user: UserMocks.userNormal(),
              ),
        ),
        ChangeNotifierProvider(
          create: (context) => transactionProvider ?? TransactionProvider(ServicesMock.txService),
        ),
        ChangeNotifierProvider(
          create: (context) => documentsProvider ?? DocumentsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => campaignManager ?? CampaignManager(),
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
      child: wrapInMaterialApp(page, navigatorObservers: navigatorObservers, locale: locale),
    );
  }

  static Future<Widget> wrapPublicRoute(
    Widget page, {
    Key? key,
    Locale? locale,
    List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
  }) async {
    await dotenv.load(fileName: "env/.env-test");

    return ChangeNotifierProvider(
      create: (context) => AppProvider(
        packageInfo: PackageInfo(
          appName: 'rec',
          packageName: 'com.barcelona.rec',
          version: '2.0.0',
          buildNumber: '8',
        ),
      ),
      child: wrapInMaterialApp(
        page,
        key: key,
        locale: locale,
        navigatorObservers: navigatorObservers,
      ),
    );
  }

  static Future<Widget> wrapPublicWidget(Widget page) {
    return wrapPublicRoute(page);
  }

  static Widget wrapInMaterialApp(
    Widget widget, {
    Key? key,
    List<NavigatorObserver> navigatorObservers = const <NavigatorObserver>[],
    Locale? locale,
  }) {
    return RecTheme(
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Localizations(
            delegates: [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              AppLocalizations.delegate
            ],
            locale: locale ?? Locale('es'),
            child: widget,
          ),
        ),
        navigatorObservers: navigatorObservers,
      ),
      data: recTheme,
    );
  }

  static String? richTextToPlainText(final Widget widget) {
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
  static void widgetExists(Widget page, {Matcher matcher = findsOneWidget}) {
    expect(find.byWidget(page), matcher);
  }

  /// Expects a widget to exists, from a widget Type
  /// `widgetExistsByType(Text)`
  static void widgetExistsByType(Type page, {Matcher matcher = findsOneWidget}) {
    expect(find.byType(page), matcher);
  }

  static void widgetExistsByKey(Key key, {Matcher matcher = findsOneWidget}) {
    expect(find.byKey(key), matcher);
  }

  /// Expects a widget to exists, from a widget Type
  /// `widgetExistsByType('text')`
  static void isTextPresent(String text, {Matcher matcher = findsOneWidget}) {
    expect(find.text(text), matcher);
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
