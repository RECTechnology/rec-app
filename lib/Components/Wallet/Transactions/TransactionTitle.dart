import 'package:flutter/material.dart';
import 'package:rec/Entities/Transactions/Transaction.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/brand.dart';

class TransactionTitle extends StatefulWidget {
  final Transaction tx;
  final double fontSize;

  const TransactionTitle(
    this.tx, {
    Key key,
    this.fontSize = 14,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TransactionTitle();
  }
}

class _TransactionTitle extends State<TransactionTitle> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    var prefix = 'FROM';
    var owner = '';

    if (widget.tx.isRecharge()) {
      prefix = localizations.translate('FROM_CREDIT_CARD');
      owner = localizations.translate('CREDIT_CARD_TX');
    } else if (widget.tx.isOut()) {
      prefix = localizations.translate('TO');
      owner = widget.tx.payOutInfo.nameReceiver;
    } else if (widget.tx.isIn()) {
      prefix = localizations.translate('FROM');
      owner = widget.tx.payInInfo.nameSender;
    }

    return RichText(
      text: TextSpan(
        text: prefix,
        style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: widget.fontSize,
              color: Brand.grayDark,
              fontWeight: FontWeight.w300,
            ),
        children: <TextSpan>[
          TextSpan(
            text: ' $owner',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: widget.fontSize,
              color: Brand.grayDark,
            ),
          ),
        ],
      ),
    );
  }
}
