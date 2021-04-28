import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rec/Api/Services/wallet/ExchangersService.dart';
import 'package:rec/Helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/LemonWayPaymentWebView.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/RechargeKO.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/RechargeOK.page.dart';
import 'package:rec/Api/Services/wallet/RechargeService.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/Entities/Forms/RechargeData.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Styles/TextStyles.dart';
import 'package:rec/routes.dart';

class AttemptRecharge extends StatefulWidget {
  final RechargeData data;

  const AttemptRecharge({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AttemptRecharge();
  }

  static Future tryRegister(BuildContext context, RechargeData data) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: AttemptRecharge(data: data),
      ),
    );
  }
}

class _AttemptRecharge extends State<AttemptRecharge> {
  RechargeService rechargeService = RechargeService();
  ExchangersService exchangersService = ExchangersService();

  bool finishedOk = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    exchangersService
        .getRandom()
        .then(
          (commerce) => widget.data.commerceId = commerce.id,
        )
        .then((c) => attemptRecharge());
  }

  Future<Null> attemptRecharge() {
    var localizations = AppLocalizations.of(context);
    return rechargeService.recharge(widget.data).then(
      (value) {
        print('recharge_result: ${json.encode(value)}');

        if (value.payInInfo != null && value.payInInfo.paymentUrl != null) {
          launchPaymentUrl(value.payInInfo.paymentUrl);
          return;
        }

        setState(() {
          isLoading = false;
          finishedOk = true;
        });
      },
    ).catchError(
      (error) {
        // Hacky check, if error with pin, go back a page
        var errorMessage = localizations.translate(error.message);
        RecToast.showError(context, errorMessage);

        if (error.message == 'Incorrect Pin') {
          return Navigator.of(context).pop(errorMessage);
        }

        // Otherwise, show error
        setState(() {
          isLoading = false;
          finishedOk = false;
        });
      },
    );
  }

  Future<void> launchPaymentUrl(String url) async {
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (ctx) => LemonWayPaymentWebView(url: url),
      ),
      ModalRoute.withName(Routes.home),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localizations.translate('RECHARGE_IN_PROGRESS'),
              style: TextStyles.pageTitle,
            ),
            const SizedBox(height: 16),
            Center(
              child: LoadingIndicator(),
            )
          ],
        ),
      );
    }

    return finishedOk ? RechargeOK(amount: widget.data.amount) : RechargeKO();
  }
}
