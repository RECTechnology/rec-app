import 'package:flutter/material.dart';

class ScrollableList extends StatelessWidget {
  final List<Widget> children;
  final Widget header;
  final bool separated;
  final ScrollPhysics physics;

  const ScrollableList({
    Key key,
    this.children = const [],
    this.separated = false,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.header,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (header != null) header,
        Expanded(
          child: Scrollbar(
            thickness: 8,
            showTrackOnHover: true,
            radius: Radius.circular(3),
            child: _getListView(),
          ),
        )
      ],
    );
  }

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
}
