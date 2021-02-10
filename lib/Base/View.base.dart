import 'package:flutter/widgets.dart';
import 'package:rec/Providers/AppState.dart';

abstract class ViewBaseState<T extends StatefulWidget> extends State<T> {
  Widget buildView(BuildContext context, AppState appState);

  @override
  Widget build(BuildContext context) {
    AppState appState = AppState.of(context);
    return buildView(context, appState);
  }
}
