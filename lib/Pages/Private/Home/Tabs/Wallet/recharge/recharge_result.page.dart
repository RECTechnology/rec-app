import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/recharge_ko.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/recharge_ok.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/welcome-ltab.page.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class RechargeResultPage extends StatefulWidget {
  final String status;
  final RechargeResult result;
  final RechargeData data;

  RechargeResultPage.fromDeeplink(
    this.result,
    this.data,
    Uri uri,
    // ignore: unnecessary_null_comparison
  )   : assert(uri != null),
        status = uri.queryParameters['status'] ?? RechargeResult.STATUS_KO;

  @override
  _RechargeResultPageState createState() => _RechargeResultPageState();
}

class _RechargeResultPageState extends State<RechargeResultPage> {
  @override
  void initState() {
    super.initState();

    Timer.run(() {
      if (widget.status == RechargeResult.STATUS_CANCEL) {
        Navigator.pop(context);
        RecToast.show(context, 'RECHARGE_CANCELED');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isOk = widget.status == RechargeResult.STATUS_OK;
    var hasEnteredCampaign = widget.data.willEnterCampaign;

    if (isOk && hasEnteredCampaign) {
      return LtabWelcomePage();
    }

    if (isOk) {
      return RechargeOK(amount: widget.data.amount);
    }

    return RechargeKO();
  }
}
