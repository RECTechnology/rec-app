import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/styles/box_decorations.dart';

class OutlinedListTile extends StatefulWidget {
  final List<Widget> children;
  final double height;
  final EdgeInsets padding;
  final Function()? onPressed;
  final Color? color;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const OutlinedListTile({
    Key? key,
    required this.children,
    this.height = 48,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    this.color,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
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
    final recTheme = RecTheme.of(context);

    return InkWell(
      onTap: widget.onPressed,
      child: Padding(
        padding: widget.padding,
        child: Container(
          height: height,
          padding: EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecorations.outline(color: widget.color ?? recTheme!.grayDark),
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: widget.crossAxisAlignment,
            mainAxisAlignment: widget.mainAxisAlignment,
            children: widget.children,
          ),
        ),
      ),
    );
  }
}
