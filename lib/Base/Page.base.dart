/*
 * This class will contain all common logic and abstract methods for a Page class
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';

abstract class PageBaseState<T extends StatefulWidget> extends State<T> {
  String title;
  Widget buildPageContent(
    BuildContext context,
    AppState state,
    AppLocalizations localizations,
  );

  PageBaseState({@required this.title});

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var state = AppState.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: buildPageContent(context, state, localizations),
      ),
    );
  }
}
