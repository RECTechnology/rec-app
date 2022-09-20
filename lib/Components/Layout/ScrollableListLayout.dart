import 'package:flutter/material.dart';
import 'package:rec/Components/Lists/ScrollableList.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/config/theme.dart';

class ScrollableListLayout extends StatelessWidget {
  final List<Widget>? children;
  final Widget? appBar;
  final Widget? header;
  final bool separated;
  final ScrollPhysics? physics;
  final Color? backgroundColor;

  ScrollableListLayout({
    Key? key,
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
    this.backgroundColor,
  }) : separated = true;

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final defaultAppBar = PrivateAppBar(
      backgroundColor: Colors.white,
      color: recTheme!.grayDark,
      size: 0,
    );

    return Scaffold(
      backgroundColor: backgroundColor ?? recTheme.defaultAvatarBackground,
      appBar: appBar as PreferredSizeWidget? ?? defaultAppBar,
      body: ScrollableList(
        header: header,
        separated: separated,
        physics: physics,
        children: children,
      ),
    );
  }
}
