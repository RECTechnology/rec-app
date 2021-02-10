import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Providers/AuthProvider.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

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
      initialRoute: InitialRoutes.getInitialRoute(hasToken: hasToken),
      routes: ROUTES,
    );
  }
}
