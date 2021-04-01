import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/Page.base.dart';
import 'package:rec/Components/IconButton.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';

abstract class GenericRecBaseScreenState<T extends StatefulWidget>
    extends PageBaseState<T> {
  bool hasAppBar = false;
  bool canGoBack = false;
  List<Widget> menuItems = [];

  GenericRecBaseScreenState({String title, this.hasAppBar, this.menuItems})
      : super(title: title);

  Widget getBackAction() {
    return IconButtonRec(
      onPressed: goBack,
      icon: Icon(Icons.arrow_back),
    );
  }

  List<Widget> getActions() {
    var actions = [];
    if (canGoBack) {
      actions.add(getBackAction());
    }

    actions.addAll(menuItems);
    return actions;
  }

  AppBar createAppBar() {
    return AppBar(
      title: Text(title),
      actions: getActions(),
    );
  }

  void goBack() {
    //en caso de necessitar un boton o un floatingButton con una flecha que vuelva a tras o algo asi
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var appState = AppState.of(context);
    var userState = UserState.of(context);

    return buildPageContent(context, appState, userState, localizations);
  }
}
