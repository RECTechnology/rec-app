import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/PayAddress.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/LinkText.dart';
import 'package:rec/Components/User/UserBalance.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Environments/env.dart';
import 'package:rec/Helpers/Deeplinking.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/charge/ChargeQr.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';
import 'package:share/share.dart';

class ChargePage extends StatefulWidget {
  const ChargePage({
    Key key,
  }) : super(key: key);

  @override
  _ChargePageState createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  final _formKey = GlobalKey<FormState>();
  final PaymentData paymentData = PaymentData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (paymentData.concept.isEmpty) {
      var localizations = AppLocalizations.of(context);
      var userState = UserState.of(context);

      paymentData.address = userState.account.recAddress;
      paymentData.concept = localizations.translate(
        'CHARGE_TO',
        params: {
          'name': userState.account.name,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var userState = UserState.of(context);
    var color = Brand.getColorForAccount(userState.account);

    return Scaffold(
      appBar: PrivateAppBar(
        hasBackArrow: true,
        selectAccountEnabled: false,
        size: 160,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: UserBalance(
            balance: paymentData.amount,
            label: paymentData.concept,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Paddings.page,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CaptionText('FILL_CHARGE_FORM'),
                const SizedBox(height: 24),
                _chargeForm(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 24,
              left: 32,
              right: 32,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share, size: 16, color: color),
                      SizedBox(width: 8),
                      LinkText(
                        localizations.translate('SHARE_PAY_LINK'),
                        color: color,
                        onTap: () {
                          var payUrl = Deeplinking.constructPayUrl(
                            env,
                            paymentData,
                          );
                          var payText = localizations.translate(
                            'PAYMENT_SHARE_MESSAGE',
                            params: {
                              'account': userState.account.name,
                              'concept': paymentData.concept,
                              'amount': paymentData.amount,
                              'link': payUrl,
                            },
                          );
                          Share.share(payText).then((c) {
                            Navigator.of(context).pop();
                          });
                        },
                      ),
                    ],
                  ),
                  RecActionButton(
                    label: localizations.translate('CHARGE_QR'),
                    backgroundColor: color,
                    onPressed: _isFormValid() ? _proceedWithPayment : null,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chargeForm() {
    return PayAddressForm(
      data: paymentData,
      formKey: _formKey,
      onChange: (data) {
        setState(() => paymentData.update(data));
      },
    );
  }

  bool _isFormValid() {
    return paymentData.concept != null &&
        paymentData.concept.isNotEmpty &&
        paymentData.amount != null &&
        paymentData.amount > 0;
  }

  void _proceedWithPayment() {
    if (!_formKey.currentState.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (c) => ChargeQr(paymentData),
      ),
    );
  }
}
