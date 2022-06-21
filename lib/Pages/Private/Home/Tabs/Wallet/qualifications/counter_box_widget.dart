import 'package:flutter/material.dart';

class CounterBoxWidget extends StatelessWidget {
  final int count;

  const CounterBoxWidget({
    Key? key,
    this.count = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: Center(
        child: Text(
          count.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
