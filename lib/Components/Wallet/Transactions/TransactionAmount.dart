import 'package:flutter/material.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class TransactionAmount extends StatefulWidget {
  final Transaction tx;
  final double fontSize;

  const TransactionAmount(
    this.tx, {
    Key? key,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TransactionAmount();
  }
}

class _TransactionAmount extends State<TransactionAmount> {
  @override
  Widget build(BuildContext context) {
    var amount = '0.00 R';
    var color = Brand.primaryColor;

    if (widget.tx.isOut()) {
      amount = '-${widget.tx.scaledAmount.toStringAsFixed(2)} R';
      color = Brand.amountNegative;
    } else {
      amount = '+${widget.tx.scaledAmount.toStringAsFixed(2)} R';
      color = Brand.primaryColor;
    }

    return Text(
      amount,
      style: TextStyle(
        fontSize: widget.fontSize,
        color: color,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
