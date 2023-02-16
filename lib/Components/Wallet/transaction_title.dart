import 'package:flutter/material.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/helpers/transactions_utils.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class TransactionTitle extends StatefulWidget {
  final Transaction tx;
  final int? maxLines;
  final double fontSize;

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
    final localizations = AppLocalizations.of(context);
    final account = UserState.of(context).account;
    final recTheme = RecTheme.of(context);

    String prefix = TransactionHelper.getPrefix(widget.tx, account as Account);
    String owner = TransactionHelper.getOwner(widget.tx, account, context);

    prefix = localizations!.translate(prefix);
    owner = localizations.translate(owner);

    return RichText(
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: prefix,
        style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: widget.fontSize,
              color: recTheme!.grayDark,
              fontWeight: FontWeight.w300,
            ),
        children: <TextSpan>[
          TextSpan(
            text: ' $owner',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: widget.fontSize,
              color: recTheme.grayDark,
            ),
          ),
        ],
      ),
    );
  }
}
