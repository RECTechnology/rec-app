import 'package:flutter/material.dart';
import 'package:rec/Api/Providers/AuthProvider.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var token = await AuthProvider.getToken();
  runApp(MyApp(token));
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
    String initialRoute =
        hasToken ? InitialRoutes.loggedIn : InitialRoutes.notLoggedIn;
    return MaterialApp(
      title: appName,
      theme: _createTheme(),
      initialRoute: initialRoute,
      routes: ROUTES,
    );
  }
}
