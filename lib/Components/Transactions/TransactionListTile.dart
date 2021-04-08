import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/CircleAvatar.dart';
import 'package:rec/Entities/Transaction.ent.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/brand.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    var title = getTitle();
    var concept = getConcept();
    var icon = getIcon();
    var amount = getAmount();
    var date = getDate();

    return Padding(
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
    );
  }

  Widget getTitle() {
    var localizations = AppLocalizations.of(context);

    var prefix = 'FROM';
    var owner = '';

    if (tx.isRecharge()) {
      prefix = localizations.translate('FROM_CREDIT_CARD');
      owner = localizations.translate('CREDIT_CARD_TX');
    } else if (tx.isOut()) {
      prefix = localizations.translate('TO');
      owner = tx.payOutInfo.nameReceiver;
    } else if (tx.isIn()) {
      prefix = localizations.translate('FROM');
      owner = tx.payInInfo.nameSender;
    }

    return RichText(
      text: TextSpan(
        text: prefix,
        style: DefaultTextStyle.of(context)
            .style
            .copyWith(fontSize: 14, color: Brand.grayDark),
        children: <TextSpan>[
          TextSpan(
            text: ' $owner',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Brand.grayDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget getIcon() {
    if (tx.isRecharge()) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Brand.defaultAvatarBackground,
          shape: BoxShape.circle,
        ),
        child: Center(child: Icon(Icons.credit_card, color: Brand.grayDark)),
      );
    }

    if (tx.isOut()) {
      return CircleAvatarRec(
        imageUrl: tx.payOutInfo.imageReceiver,
        name: tx.payOutInfo.nameReceiver,
        size: 40,
      );
    }

    return CircleAvatarRec(
      size: 40,
      imageUrl: tx.payInInfo.imageSender,
      name: tx.payInInfo.nameSender,
    );
  }

  Text getConcept() {
    var localizations = AppLocalizations.of(context);
    var concept = '';

    if (tx.isRecharge()) {
      concept = 'RECHARGE_EUR_REC';
    } else if (tx.isOut()) {
      concept = tx.payOutInfo.concept;
    } else if (tx.isIn()) {
      concept = tx.payInInfo.concept;
    }

    return Text(
      localizations.translate(concept.isEmpty ? 'NO_CONCEPT' : concept),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 14, color: Brand.grayDark2),
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
        fontSize: 14,
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
