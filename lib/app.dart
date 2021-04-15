import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class RecApp extends StatefulWidget {
  final String token;

  RecApp(this.token);

  @override
  _RecAppState createState() => _RecAppState();
}

class _RecAppState extends State<RecApp> {
  @override
  Widget build(BuildContext context) {
    var hasToken = widget.token != null;

    return MaterialApp(
      title: Brand.appName,
      theme: Brand.createTheme(),
      supportedLocales: [
        Locale('en', 'UK'),
        Locale('ca', 'CA'),
        Locale('es', 'ES')
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode ||
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      initialRoute: Routes.getInitialRoute(hasToken: hasToken),
      routes: ROUTES,
      builder: EasyLoading.init(),
    );
  }
}
