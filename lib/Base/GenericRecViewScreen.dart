import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Animations/SpinKit.dart';
import 'package:rec/Base/GenericBaseStcreen.dart';
import 'package:rec/Base/Page.base.dart';
import 'package:rec/Components/ItemColumn.dart';
import 'package:rec/Providers/AppState.dart';

abstract class GenericRecViewScreen<T extends GenericRecBaseScreen>
    extends State {
  final List<Widget> widgetList;
  final Form form;

  Widget buildPageContent(BuildContext context, AppState state);

  GenericRecViewScreen({Key key, this.widgetList, this.form}) : super();

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
