/*
 * This class will contain all common logic and abstract methods for a Page class
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';

abstract class PageBaseState<T extends StatefulWidget> extends State<T> {
  String title;
  Widget buildPageContent(
    BuildContext context,
    AppState appState,
    UserState userState,
    AppLocalizations localizations,
  );

  PageBaseState({@required this.title});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var appState = AppState.of(context);
    var userState = UserState.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: buildPageContent(context, appState, userState, localizations),
      ),
    );
  }
}
