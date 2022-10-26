import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';

class ListViewExtra extends StatefulWidget {
  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? noItemsBuilder;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final EdgeInsets? padding;

  final int itemCount;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ListViewExtra({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.shrinkWrap = false,
    this.physics,
    this.headerBuilder,
    this.padding,
    this.separatorBuilder,
    this.noItemsBuilder,
  }) : super(key: key);

  @override
  State<ListViewExtra> createState() => _ListViewExtraState();
}

class _ListViewExtraState extends State<ListViewExtra> {
  int itemCount = 0;
  bool hasItems = false;

  @override
  void initState() {
    _setup();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _setup();
    setState(() {});
    super.didChangeDependencies();
  }

  void _setup() {
    itemCount = widget.itemCount;
    hasItems = true;

    if (widget.headerBuilder != null) {
      itemCount += 1;
    }

    if (widget.itemCount <= 0) {
      itemCount += 1;
      hasItems = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      padding: widget.padding,
      itemBuilder: (innerContext, index) {
        // If there is a headerBuilder and index is 0, use that builder
        if (index == 0 && widget.headerBuilder != null) {
          return widget.headerBuilder!(innerContext);
        }

        // If there are no items, show no items widget or supplied builder
        if (index == 1 || index == 0 && !hasItems) {
          return widget.noItemsBuilder == null
              ? _noItemsBuilder(context)
              : widget.noItemsBuilder!(innerContext);
        }

        return widget.itemBuilder(innerContext, index - (widget.headerBuilder != null ? 1 : 0));
      },
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      separatorBuilder: widget.separatorBuilder ?? (_, __) => SizedBox.shrink(),
    );
  }

  _noItemsBuilder(BuildContext context) {
    return ListTile(
      title: LocalizedText('NO_ITEMS'),
    );
  }
}
