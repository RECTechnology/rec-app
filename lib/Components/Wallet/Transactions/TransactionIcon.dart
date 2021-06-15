import 'package:flutter/material.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Entities/Transactions/Transaction.ent.dart';
import 'package:rec/Providers/CampaignProvider.dart';
import 'package:rec/Providers/UserState.dart';
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
        ? transaction.payOutInfo.image
        : transaction.payInInfo.image;
  }

  String _getName(Transaction transaction) {
    return transaction.isOut()
        ? transaction.payOutInfo.name
        : transaction.payInInfo.name;
  }

  @override
  Widget build(BuildContext context) {
    var account = UserState.of(context).account;
    var activeCampaign = CampaignProvider.of(context).activeCampaign;

    if (widget.tx.isIn() && account.isLtabAccount()) {
      return CircleAvatarRec(
        imageUrl: activeCampaign == null ? '' : activeCampaign.imageUrl,
        color: Brand.defaultAvatarBackground,
      );
    }

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
