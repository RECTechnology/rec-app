import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  final IndexedWidgetBuilder? builder;
  final int itemCount;
  final List<Widget>? children;
  final EdgeInsets padding;

  const HorizontalList({
    Key? key,
    this.children = const [],
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  })  : builder = null,
        itemCount = 0,
        super(key: key);

  const HorizontalList.builder({
    Key? key,
    required this.builder,
    required this.itemCount,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
  })  : children = null,
        assert(itemCount > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (builder != null) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: builder!,
        padding: padding,
      );
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      children: children!,
    );
  }
}
