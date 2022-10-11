import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/transactions/transaction_details_sheet.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Wallet/transaction_icon.dart';
import 'package:rec/Components/Wallet/transaction_title.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/transactions_utils.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:timeago/timeago.dart' as timeago;

class TransactionsListTile extends StatefulWidget {
  final Transaction tx;
  final double height;
  final EdgeInsets padding;

  const TransactionsListTile({
    Key? key,
    required this.tx,
    this.height = 55,
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TransactionsListTile();
  }
}

class _TransactionsListTile extends State<TransactionsListTile> {
  Transaction get tx {
    return widget.tx;
  }

  double get height {
    return widget.height;
  }

  void _openTxDetails() {
    TransactionBottomSheet.openBottomSheet(context, widget.tx);
  }

  @override
  Widget build(BuildContext context) {
    final title = TransactionTitle(widget.tx, maxLines: 1);
    final icon = TransactionIcon(widget.tx);
    final recTheme = RecTheme.of(context);

    final concept = getConcept(recTheme!);
    final amount = getAmount(recTheme);
    final date = getDate(recTheme);

    return InkWell(
      onTap: _openTxDetails,
      child: Padding(
        padding: widget.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                height: height,
                width: height,
                child: icon,
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: height,
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [title, concept],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: date,
                    ),
                    amount,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LocalizedText getConcept(RecThemeData theme) {
    final account = UserState.of(context).account;
    final cultureCampaign = CampaignProvider.of(context).getCampaignByCode(env.CMP_CULT_CODE);
    var concept = TransactionHelper.getConcept(tx);

    // HACK
    if (tx.isIn() && account != null && account.isLtabAccount()) {
      concept = 'LTAB_REWARD';
    }

    return LocalizedText(
      concept!.isEmpty ? 'NO_CONCEPT' : concept,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      params: {
        'percent': cultureCampaign!.percent,
      },
      style: TextStyle(
        fontSize: 16,
        color: theme.grayDark2,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Text getAmount(RecThemeData theme) {
    var amount = '0.00 R';
    var color = theme.primaryColor;

    if (tx.isOut()) {
      amount = '-${tx.scaledAmount.toStringAsFixed(2)} R';
      color = theme.negativeAmount;
    } else {
      amount = '+${tx.scaledAmount.toStringAsFixed(2)} R';
      color = theme.positiveAmount;
    }

    return Text(
      amount,
      style: TextStyle(
        fontSize: 16,
        color: color,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Text getDate(RecThemeData theme) {
    final localizations = AppLocalizations.of(context);
    final daysSinceCreated = Duration(
      milliseconds: DateTime.now().millisecondsSinceEpoch - tx.createdAt.millisecondsSinceEpoch,
    ).inDays;

    var dateString = DateFormat('d MMM', localizations!.locale.languageCode).format(tx.createdAt);

    if (daysSinceCreated <= 1) {
      dateString = timeago.format(
        tx.createdAt,
        locale: localizations.locale.languageCode,
      );
    }

    return Text(
      dateString,
      style: TextStyle(
        fontSize: 12,
        color: theme.grayLight,
      ),
    );
  }
}
