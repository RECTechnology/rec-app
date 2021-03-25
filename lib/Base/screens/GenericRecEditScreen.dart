import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericBaseScreen.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';

abstract class GenericRecEditScreen<T extends StatefulWidget>
    extends GenericRecBaseScreenState<T> {
  final formKey = GlobalKey<FormState>();

  GenericRecEditScreen({
    String title,
    bool hasAppBar,
  }) : super(title: title, hasAppBar: hasAppBar);

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
