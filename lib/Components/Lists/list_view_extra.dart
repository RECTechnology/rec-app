import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';

class ListViewExtra extends StatefulWidget {
  final WidgetBuilder? headerBuilder;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final EdgeInsets? padding;

  final int itemCount;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  ListViewExtra({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.shrinkWrap = false,
    this.physics,
    this.headerBuilder,
    this.padding,
    this.separatorBuilder,
  }) : super(key: key);

  @override
  State<ListViewExtra> createState() => _ListViewExtraState();
}

class _ListViewExtraState extends State<ListViewExtra> {
  int itemCount = 0;

  @override
  void initState() {
    itemCount = widget.itemCount;
    if (widget.headerBuilder != null) {
      itemCount += 1;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: recTheme!.primaryColor),
      ),
      child: ListView.separated(
        itemCount: itemCount,
        padding: widget.padding,
        itemBuilder: (innerContext, index) {
          if (index == 0 && widget.headerBuilder != null) {
            return widget.headerBuilder!(innerContext);
          }

          return widget.itemBuilder(innerContext, index - (widget.headerBuilder != null ? 1 : 0));
        },
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        separatorBuilder: widget.separatorBuilder ?? (_, __) => SizedBox.shrink(),
      ),
    );
  }
}
