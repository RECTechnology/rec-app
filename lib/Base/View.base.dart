import 'package:flutter/widgets.dart';

abstract class ViewBaseState<T extends StatefulWidget> extends State<T> {
  Widget buildView(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildView(context);
  }
}
