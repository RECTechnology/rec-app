import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericBaseScreen.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';

abstract class GenericRecViewScreen<T extends StatefulWidget>
    extends GenericRecBaseScreenState {
  GenericRecViewScreen({
    String title,
    bool hasAppBar,
  }) : super(title: title, hasAppBar: hasAppBar);

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var appState = AppState.of(context);
    var userState = UserState.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(1.0),
        child: buildPageContent(context, appState, userState, localizations),
      ),
    );
  }
}
