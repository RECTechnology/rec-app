import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/PayAddress.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Layout/FormPageLayout.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/LinkText.dart';
import 'package:rec/Components/Wallet/user_balance.dart';
import 'package:rec/config/features.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/Deeplinking.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/charge/ChargeQr.page.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:share/share.dart';

class ChargePage extends StatefulWidget {
  const ChargePage({
    Key? key,
  }) : super(key: key);

  @override
  _ChargePageState createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> {
  final _formKey = GlobalKey<FormState>();
  final PaymentData paymentData = PaymentData.empty();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (paymentData.concept.isEmpty) {
      var localizations = AppLocalizations.of(context);
      var userState = UserState.of(context);

      paymentData.address = userState.account!.recAddress;
      paymentData.concept = localizations!.translate(
        'PAY_TO_NAME',
        params: {
          'name': userState.account!.name,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final userState = UserState.of(context);
    final recTheme = RecTheme.of(context);
    final color = recTheme!.accountTypeColor(userState.account?.type ?? Account.TYPE_PRIVATE);

    final appBar = PrivateAppBar(
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
    );

    return FormPageLayout(
      appBar: appBar,
      header: _topText(),
      form: _chargeForm(),
      submitButton: Column(
        children: [
          SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.share, size: 16, color: color),
              const SizedBox(width: 8),
              if (Features.sharePayLink)
                LinkText(
                  localizations!.translate('SHARE_PAY_LINK'),
                  color: color,
                  onTap: () {
                    var payUrl = DeepLinking.constructPayUrl(
                      env,
                      paymentData,
                    );
                    var payText = localizations.translate(
                      'PAYMENT_SHARE_MESSAGE',
                      params: {
                        'account': userState.account!.name,
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
          SizedBox(height: 16),
          RecActionButton(
            padding: EdgeInsets.zero,
            label: localizations!.translate('CHARGE_QR'),
            backgroundColor: color,
            onPressed: _isFormValid() ? _proceedWithPayment : null,
          )
        ],
      ),
    );
  }

  Widget _topText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: CaptionText('FILL_CHARGE_FORM'),
    );
  }

  Widget _chargeForm() {
    return PayAddressForm(
      data: paymentData,
      formKey: _formKey,
      onSubmitted: (d) {
        _formChanged(d);
        _proceedWithPayment();
      },
      onChange: _formChanged,
    );
  }

  void _formChanged(data) {
    setState(() => paymentData.update(data));
  }

  bool _isFormValid() {
    return paymentData.concept.isNotEmpty && paymentData.amount != null && paymentData.amount! > 0;
  }

  void _proceedWithPayment() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (c) => ChargeQrPage(paymentData),
      ),
    );
  }
}
