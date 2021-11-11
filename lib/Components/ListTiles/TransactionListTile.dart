import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/Modals/TransactionDetailsModal.dart';
import 'package:rec/Components/Wallet/Transactions/TransactionIcon.dart';
import 'package:rec/Components/Wallet/Transactions/TransactionTitle.dart';
import 'package:rec/Entities/Transactions/Transaction.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:timeago/timeago.dart' as timeago;

// TODO: Improve how we handle diferent transaction types
//       I would suggest creating a diferent ListTile per transaction type,
//       Transaction type would be set on instantiation, from (rules)
//       then on build we render a diferent tile per type of transaction
class TransactionsListTile extends StatefulWidget {
  final Transaction tx;
  final double height;
  final EdgeInsets padding;

  const TransactionsListTile({
    Key key,
    @required this.tx,
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

  @override
  Widget build(BuildContext context) {
    var title = TransactionTitle(widget.tx);
    var icon = TransactionIcon(widget.tx);

    var concept = getConcept();
    var amount = getAmount();
    var date = getDate();

    var detailsModal = TransactionDetailsModal(context);

    return InkWell(
      onTap: () => detailsModal.open(widget.tx),
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

  Text getConcept() {
    var account = UserState.of(context).account;
    var localizations = AppLocalizations.of(context);
    var concept = tx.getConcept();

    // HACK
    if (tx.isIn() && account.isLtabAccount()) {
      concept = 'LTAB_REWARD';
    }

    return Text(
      localizations.translate(concept.isEmpty ? 'NO_CONCEPT' : concept),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        color: Brand.grayDark2,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Text getAmount() {
    var amount = '0.00 R';
    var color = Brand.primaryColor;

    if (tx.isOut()) {
      amount = '-${tx.scaledAmount.toStringAsFixed(2)} R';
      color = Brand.amountNegative;
    } else {
      amount = '+${tx.scaledAmount.toStringAsFixed(2)} R';
      color = Brand.primaryColor;
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

  Text getDate() {
    var localizations = AppLocalizations.of(context);
    var daysSinceCreated = Duration(
      milliseconds: DateTime.now().millisecondsSinceEpoch -
          tx.createdAt.millisecondsSinceEpoch,
    ).inDays;

    var dateString = DateFormat('d MMM', localizations.locale.languageCode)
        .format(tx.createdAt);

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
        color: Brand.grayLight,
      ),
    );
  }
}
