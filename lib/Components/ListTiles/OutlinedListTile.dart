import 'package:flutter/material.dart';
import 'package:rec/Styles/BoxDecorations.dart';
import 'package:rec/brand.dart';

class OutlinedListTile extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final EdgeInsets padding;
  final Function() onPressed;
  final Color color;
  final CrossAxisAlignment alignment;

  const OutlinedListTile({
    Key key,
    @required this.children,
    this.height = 48,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    this.color = Brand.grayDark,
    this.alignment = CrossAxisAlignment.start,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OutlinedListTile();
  }
}

class _OutlinedListTile extends State<OutlinedListTile> {
  double get height {
    return widget.height;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Padding(
        padding: widget.padding,
        child: Row(
          crossAxisAlignment: widget.alignment,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                height: height,
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecorations.outline(color: widget.color),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: widget.children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
