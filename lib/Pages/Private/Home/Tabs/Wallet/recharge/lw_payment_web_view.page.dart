import 'package:flutter/material.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/Deeplinking.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/recharge_result.page.dart';
import 'package:rec/Pages/Private/Shared/InAppBrowser.dart';
import 'package:rec/providers/All.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class LemonWayPaymentWebView extends StatefulWidget {
  final String? url;
  final RechargeResult rechargeResult;
  final RechargeData rechargeData;

  const LemonWayPaymentWebView({
    Key? key,
    required this.url,
    required this.rechargeResult,
    required this.rechargeData,
  }) : super(key: key);

  @override
  _LemonWayPaymentWebView createState() => _LemonWayPaymentWebView();
}

class _LemonWayPaymentWebView extends State<LemonWayPaymentWebView> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);

    return InAppBrowser(
      title: localizations!.translate('RECHARGE'),
      url: widget.url,
      debug: false,
      onPageFinished: (url) {
        _pageChanged(url, 'finished');
      },
      onPageStarted: (url) {
        _pageChanged(url, 'started');
      },
    );
  }

  void _pageChanged(String url, String state) {
    print('_pageChanged $state: $url');

    // Quick and dirty way of checking if the url redirected to a deeplink
    // that matches recharge-result path
    final isRechargeResultUrl = DeepLinking.matchesRechargeResultUri(env, url);

    if (isRechargeResultUrl) {
      Navigator.of(context).pop();
      UserState.deaf(context).getUser();
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
  }
}
