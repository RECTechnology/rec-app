import 'package:flutter/material.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/LemonWayPaymentWebView.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/RechargeKO.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/RechargeOK.page.dart';
import 'package:rec/Components/Indicators/LoadingIndicator.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AttemptRecharge extends StatefulWidget {
  final RechargeData data;

  const AttemptRecharge({
    Key? key,
    required this.data,
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
  RechargeService rechargeService = RechargeService(env: env);

  bool finishedOk = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    attemptRecharge();
  }

  Future<void> attemptRecharge() {
    return rechargeService.recharge(widget.data).then(
      (value) {
        if (value.status == 'failed') {
          setState(() {
            isLoading = false;
            finishedOk = false;
          });
          return;
        }

        if (value.payInInfo != null && value.payInInfo!.paymentUrl != null) {
          launchPaymentUrl(value);
          return;
        }

        setState(() {
          isLoading = false;
          finishedOk = true;
        });
      },
    ).catchError(
      (error) {
        RecToast.showError(context, error.message);

        if (error.message == 'Incorrect Pin') {
          Navigator.of(context).pop(error.message);
          return;
        }

        // Otherwise, show error
        setState(() {
          isLoading = false;
          finishedOk = false;
        });
      },
    );
  }

  Future<void> launchPaymentUrl(RechargeResult rechargeResult) async {
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (ctx) => LemonWayPaymentWebView(
          url: rechargeResult.payInInfo!.paymentUrl,
          rechargeResult: rechargeResult,
          rechargeData: widget.data,
        ),
      ),
      ModalRoute.withName(Routes.home),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LocalizedText(
                'RECHARGE_IN_PROGRESS',
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Center(
                child: LoadingIndicator(),
              )
            ],
          ),
        ),
      );
    }

    return finishedOk ? RechargeOK(amount: widget.data.amount) : RechargeKO();
  }
}
