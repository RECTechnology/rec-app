import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rec/Entities/Forms/RechargeData.dart';
import 'package:rec/Entities/Transactions/RechargeResult.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/LtabCampaign/WelcomeToCampaign.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/RechargeKO.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/RechargeOK.page.dart';

class RechargeResultPage extends StatefulWidget {
  final String status;
  final RechargeResult result;
  final RechargeData data;

  RechargeResultPage.fromDeeplink(
    this.result,
    this.data,
    Uri uri,
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
    var hasEnteredCampaign =
        widget.data != null && widget.data.willEnterCampaign;

    if (isOk && hasEnteredCampaign) {
      return WelcomeToCampaign(amount: widget.result.amount ?? 0.0);
    }

    if (isOk) {
      return RechargeOK(amount: widget.result.amount ?? 0.0);
    }

    return RechargeKO();
  }
}
