import 'package:flutter/material.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Entities/Transactions/Transaction.ent.dart';
import 'package:rec/brand.dart';

class TransactionIcon extends StatefulWidget {
  final Transaction tx;

  const TransactionIcon(
    this.tx, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TransactionIcon();
  }
}

class _TransactionIcon extends State<TransactionIcon> {
  String _getImage(Transaction transaction) {
    return transaction.isOut()
        ? transaction.payOutInfo.imageReceiver
        : transaction.payInInfo.imageSender;
  }

  String _getName(Transaction transaction) {
    return transaction.isOut()
        ? transaction.payOutInfo.nameReceiver
        : transaction.payInInfo.nameSender;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tx.isRecharge()) {
      return CircleAvatarRec.withIcon(
        Icon(
          Icons.credit_card,
          color: Brand.grayDark,
        ),
        color: Brand.defaultAvatarBackground,
      );
    }

    return CircleAvatarRec(
      imageUrl: _getImage(widget.tx),
      name: _getName(widget.tx),
    );
  }
}
