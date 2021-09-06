import 'package:flutter/material.dart';
import 'package:rec/Components/Lists/ScrollableList.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/brand.dart';

class ScrollableListLayout extends StatelessWidget {
  final List<Widget> children;
  final Widget appBar;
  final Widget header;
  final bool separated;
  final ScrollPhysics physics;
  final Color backgroundColor;

  final defaultAppBar = PrivateAppBar(
    backgroundColor: Colors.white,
    color: Brand.grayDark,
    size: 0,
  );

  ScrollableListLayout({
    Key key,
    this.children = const <Widget>[],
    this.separated = false,
    this.appBar,
    this.physics,
    this.header,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  ScrollableListLayout.separated({
    this.children,
    this.appBar,
    this.physics,
    this.header,
    this.backgroundColor = Brand.defaultAvatarBackground,
  }) : separated = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar ?? defaultAppBar,
      body: ScrollableList(
        header: header,
        separated: separated,
        physics: physics,
        children: children,
      ),
    );
  }
}
