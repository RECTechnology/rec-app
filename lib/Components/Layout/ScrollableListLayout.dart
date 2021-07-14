import 'package:flutter/material.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/brand.dart';

class ScrollableListLayout extends StatelessWidget {
  final List<Widget> children;
  final Widget appBar;
  final bool separated;
  final ScrollPhysics physics;

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
  }) : super(key: key);

  ScrollableListLayout.separated({
    this.children,
    this.appBar,
    this.physics,
  }) : separated = true;

  ListView _getListView() {
    if (separated) {
      return ListView.separated(
        itemBuilder: (ctx, index) => children[index],
        separatorBuilder: (ctx, index) => Divider(height: 1),
        itemCount: children.length,
        physics: physics,
      );
    }

    return ListView(
      physics: physics,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? defaultAppBar,
      body: Scrollbar(
        thickness: 8,
        showTrackOnHover: true,
        radius: Radius.circular(3),
        child: _getListView(),
      ),
    );
  }
}
