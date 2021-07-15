import 'package:flutter/material.dart';
import 'package:rec/Entities/Forms/RechargeData.dart';
import 'package:rec/Entities/Transactions/RechargeResult.dart';
import 'package:rec/Environments/env.dart';
import 'package:rec/Helpers/Deeplinking.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/RechargeResult.page.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';

class LemonWayPaymentWebView extends StatefulWidget {
  final String url;
  final RechargeResult rechargeResult;
  final RechargeData rechargeData;

  const LemonWayPaymentWebView({
    Key key,
    @required this.url,
    @required this.rechargeResult,
    @required this.rechargeData,
  }) : super(key: key);

  @override
  _LemonWayPaymentWebView createState() => _LemonWayPaymentWebView();
}

class _LemonWayPaymentWebView extends State<LemonWayPaymentWebView> {
  @override
  Widget build(BuildContext context) {
    return InAppBrowser(
      url: widget.url,
      debug: true,
      onPageStarted: (url) {
        // Quick and dirty way of checking if the url redirected to a deeplink
        // That matches recharge-result path
        var isRechargeResultUrl = DeepLinking.matchesRechargeResultUri(
          env,
          url,
        );

        if (isRechargeResultUrl) {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return RechargeResultPage.fromDeeplink(
                  widget.rechargeResult,
                  widget.rechargeData,
                  Uri.parse(url),
                );
              },
            ),
          );
        }
      },
    );
  }
}
