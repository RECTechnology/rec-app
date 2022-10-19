import 'package:flutter/material.dart';
import 'package:rec/Components/Info/formatted_date.dart';
import 'package:rec/Components/Wallet/transaction_title.dart';
import 'package:rec/Components/Wallet/amount_widget.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RefundListTile extends StatelessWidget {
  final Transaction tx;

  const RefundListTile({Key? key, required this.tx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TransactionTitle(tx, fontSize: 14),
            FormattedDate(date: tx.createdAt, style: TextStyle(fontSize: 14)),
          ],
        ),
        AmountWidget(
          amount: tx.scaledAmount,
          isNegative: tx.isOut(),
        )
      ],
    );
  }
}
