import 'package:flutter/material.dart';
import 'package:rec/Components/Info/RecQrImage.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Environments/env.dart';
import 'package:rec/Helpers/Deeplinking.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class ChargeQr extends StatefulWidget {
  final PaymentData paymentData;

  const ChargeQr(
    this.paymentData, {
    Key key,
  }) : super(key: key);

  @override
  _ChargeQrState createState() => _ChargeQrState();
}

class _ChargeQrState extends State<ChargeQr> {
  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var userState = UserState.of(context);
    var color = Brand.getColorForAccount(userState.account);
    var payUrl = DeepLinking.constructPayUrl(env, widget.paymentData);

    return Scaffold(
      appBar: PrivateAppBar(
        hasBackArrow: true,
        selectAccountEnabled: false,
        size: 160,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: UserBalance(
            balance: widget.paymentData.amount,
            label: widget.paymentData.concept,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              localizations.translate('QR_CHARGE_MESSAGE'),
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            RecQrImage(payUrl),
            Align(
              alignment: Alignment.bottomCenter,
              child: RecActionButton(
                label: localizations.translate('FINALIZE'),
                backgroundColor: color,
                onPressed: () => Navigator.of(context).popUntil(
                  ModalRoute.withName(Routes.home),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
