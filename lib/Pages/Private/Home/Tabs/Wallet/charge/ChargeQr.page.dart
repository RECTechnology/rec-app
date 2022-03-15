import 'package:flutter/material.dart';
import 'package:rec/Components/Info/RecQrImage.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/Deeplinking.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class ChargeQrPage extends StatefulWidget {
  final PaymentData paymentData;

  const ChargeQrPage(
    this.paymentData, {
    Key? key,
  }) : super(key: key);

  @override
  _ChargeQrPageState createState() => _ChargeQrPageState();
}

class _ChargeQrPageState extends State<ChargeQrPage> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    var color = Brand.getColorForAccount(userState.account as Account);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              LocalizedText(
                'QR_CHARGE_MESSAGE',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              RecQrImage(payUrl),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.bottomCenter,
                child: RecActionButton(
                  label: 'FINALIZE',
                  backgroundColor: color,
                  onPressed: () => Navigator.of(context).popUntil(
                    ModalRoute.withName(Routes.home),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
