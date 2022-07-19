import 'package:flutter/material.dart';
import 'package:rec/config/brand.dart';

/// This widget receives an [itemCount] and a [itemBuilder] as well as an optional [currentItemIndex]
///
/// It builds a timeline (vertical), for each item it will call [itemBuilder], it will use [currrItemIndex] to mark the item as "selected"
/// It will also receive styles to customize the timeline
///
/// NOTE: Parent widget must provide items sorted

class TimelineWidget extends StatefulWidget {
  final IndexedWidgetBuilder builder;
  final int itemCount;
  final int? currentItemIndex;

  TimelineWidget({
    Key? key,
    required this.builder,
    required this.itemCount,
    this.currentItemIndex,
  }) : super(key: key);

  @override
  State<TimelineWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.itemCount,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _TimelineRowItem(
          child: widget.builder(context, index),
          selected: index == widget.currentItemIndex,
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 18,
          margin: EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          child: VerticalDivider(
            color: Brand.grayLight5,
            width: 2,
            thickness: 3,
          ),
        );
      },
    );
  }
}

class _TimelineRowItem extends StatelessWidget {
  final Widget child;
  final bool selected;

  const _TimelineRowItem({Key? key, required this.child, required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _TimelineIndicator(selected: selected),
      title: child,
    );
  }
}

class _TimelineIndicator extends StatelessWidget {
  final bool selected;

  const _TimelineIndicator({Key? key, this.selected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = selected ? Brand.backgroundPrivateColor : Brand.grayLight5;
    final effectiveFgColor = selected ? Brand.primaryColor : Brand.grayDark3;

    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Container(
        width: 16,
        height: 16,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: effectiveFgColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
