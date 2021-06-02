import 'package:flutter/material.dart';

class RecBadge extends StatelessWidget {
  final Color color;
  final Widget child;

  const RecBadge({
    Key key,
    this.color = Colors.red,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: child ?? SizedBox(),
    );
  }
}
