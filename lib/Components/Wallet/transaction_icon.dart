import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/transactions_utils.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class TransactionIcon extends StatefulWidget {
  final Transaction tx;

  const TransactionIcon(
    this.tx, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TransactionIcon();
  }
}

class _TransactionIcon extends State<TransactionIcon> {
  String? _getImage(Transaction transaction) {
    return transaction.isOut() ? transaction.payOutInfo!.image : transaction.payInInfo!.image;
  }

  String? _getName(Transaction transaction) {
    return transaction.isOut() ? transaction.payOutInfo!.name : transaction.payInInfo!.name;
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);
    final account = UserState.of(context).account;
    final campaignProvider = CampaignProvider.of(context);
    final ltabCampaign = campaignProvider.getCampaignByCode(env.CMP_LTAB_CODE);
    final cultureCampaign = campaignProvider.getCampaignByCode(env.CMP_CULT_CODE);

    if (widget.tx.isIn() && account != null && account.isLtabAccount()) {
      return CircleAvatarRec(
        imageUrl: ltabCampaign == null ? '' : ltabCampaign.imageUrl,
        color: recTheme!.defaultAvatarBackground,
      );
    }

    if (TransactionHelper.isCultureReward(widget.tx) ||
        TransactionHelper.isChequeCulture(widget.tx)) {
      return CircleAvatarRec(
        imageUrl: cultureCampaign == null ? '' : cultureCampaign.imageUrl,
        color: recTheme!.defaultAvatarBackground,
      );
    }

    if (TransactionHelper.isRecharge(widget.tx)) {
      return CircleAvatarRec.withIcon(
        Icon(
          Icons.credit_card,
          color: recTheme!.grayDark,
        ),
        color: recTheme.defaultAvatarBackground,
      );
    }

    return CircleAvatarRec(
      imageUrl: _getImage(widget.tx),
      name: _getName(widget.tx),
    );
  }
}
