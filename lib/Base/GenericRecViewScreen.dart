import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/GenericBaseScreen.dart';
import 'package:rec/Providers/AppState.dart';

abstract class GenericRecViewScreen<T extends StatefulWidget>
    extends GenericRecBaseScreenState {
  GenericRecViewScreen({
    String title,
    bool hasAppBar,
  }) : super(title: title, hasAppBar: hasAppBar);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: buildPageContent(context, AppState.of(context)),
      ),
    );
  }
}
