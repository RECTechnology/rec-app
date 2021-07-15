import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/PayAddress.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/AttemptPayment.page.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/Styles/Paddings.dart';
import 'package:rec/brand.dart';

class PayAddress extends StatefulWidget {
  final PaymentData paymentData;
  final List<String> disabledFields;

  const PayAddress({
    Key key,
    @required this.paymentData,
    this.disabledFields = const [],
  }) : super(key: key);

  @override
  _PayAddressState createState() => _PayAddressState();
}

class _PayAddressState extends State<PayAddress> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Widget _content() {
    var localizations = AppLocalizations.of(context);
    var userState = UserState.of(context);

    return Scaffold(
      appBar: PrivateAppBar(
        hasBackArrow: true,
        selectAccountEnabled: false,
        size: 160,
        backgroundColor: Brand.defaultAvatarBackground,
        color: Brand.grayDark,
        title: localizations.translate('PAY_TO_NAME', params: {
          'name': widget.paymentData.vendor.name,
        }),
        textAlign: TextAlign.left,
        alignment: Alignment.centerLeft,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: UserBalance(
            balance: widget.paymentData.amount,
            label: localizations.translate(
              'FROM_NAME',
              params: {
                'name': userState.account.name,
              },
            ),
            color: Brand.grayDark,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: Paddings.page,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CaptionText('FILL_PAY_FORM'),
                  const SizedBox(height: 24),
                  _payForm(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 23,
                left: 32,
                right: 32,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RecActionButton(
                  label: localizations.translate('CONFIRM_PAYMENT'),
                  backgroundColor: Brand.primaryColor,
                  onPressed: _isFormValid() ? _proceedWithPayment : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _payForm() {
    return PayAddressForm(
      data: widget.paymentData,
      disabledFields: widget.disabledFields,
      formKey: _formKey,
      onChange: (data) {
        setState(() => widget.paymentData.update(data));
      },
    );
  }

  bool _isFormValid() {
    var hasConcept = Checks.isNotEmpty(widget.paymentData.concept);
    return hasConcept &&
        widget.paymentData.amount != null &&
        widget.paymentData.amount > 0;
  }

  void _proceedWithPayment() {
    if (!_formKey.currentState.validate()) return;

    FocusScope.of(context).requestFocus(FocusNode());
    _attemptPayment();
  }

  void _attemptPayment() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (ctx) => AttemptPayment(
              data: widget.paymentData,
            ),
          ),
        )
        .then((c) => Navigator.of(context).pop(c));
  }
}
