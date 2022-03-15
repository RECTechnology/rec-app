import 'package:flutter/material.dart';
import 'package:rec/helpers/transactions_utils.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class TransactionTitle extends StatefulWidget {
  final Transaction tx;
  final double fontSize;
  final int? maxLines;

  const TransactionTitle(
    this.tx, {
    Key? key,
    this.fontSize = 14,
    this.maxLines,
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
    var account = UserState.of(context).account;

    var prefix = 'FROM';
    String? owner = '';

    // HACK: LTAB
    if (widget.tx.isIn() && account!.isLtabAccount()) {
      prefix = localizations!.translate('FROM');
      owner = 'LTAB';
    }
    if (TransactionHelper.isCultureReward(widget.tx)) {
      prefix = localizations!.translate('FROM');
      owner = localizations.translate('REC_CULTURAL');
    } else if (TransactionHelper.isRecharge(widget.tx)) {
      prefix = localizations!.translate('FROM_CREDIT_CARD');
      owner = localizations.translate('CREDIT_CARD_TX');
    } else if (widget.tx.isOut()) {
      prefix = localizations!.translate('TO');
      owner = widget.tx.payOutInfo!.name;
    } else if (widget.tx.isIn()) {
      prefix = localizations!.translate('FROM');
      owner = widget.tx.payInInfo!.name;
    }

    if (owner == null || owner.isEmpty) {
      owner = localizations!.translate('PARTICULAR');
    }

    return RichText(
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
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
