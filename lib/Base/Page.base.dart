/*
 * This class will contain all common logic and abstract methods for a Page class
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class PageBaseState<T extends StatefulWidget> extends State<T> {
  String title;
  Widget buildPageContent(BuildContext context);

  PageBaseState({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: buildPageContent(context),
      ),
    );
  }
}
