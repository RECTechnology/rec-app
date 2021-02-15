import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Providers/AuthProvider.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';
import 'Lang/AppLocalizations.dart';
import 'Providers/AppState.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get the token from storage
  var token = await AuthProvider.getToken();

  // Create AppState provider
  var appStateProvider = ChangeNotifierProvider(
    create: (context) => AppState(),
    child: MyApp(token),
  );

  runApp(appStateProvider);
}

class MyApp extends StatefulWidget {
  final String token;
  MyApp(this.token);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _createTheme() {
    final baseTheme = ThemeData();
    return baseTheme.copyWith(
      primaryColor: primaryColor,
      accentColor: accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasToken = widget.token != null;

    return MaterialApp(
      title: appName,
      theme: _createTheme(),
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
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode ||
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        return supportedLocales.first;
      },
      initialRoute: InitialRoutes.getInitialRoute(hasToken: hasToken),
      routes: ROUTES,
    );
  }
}
