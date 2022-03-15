import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/PayAddress.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Layout/FormPageLayout.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/AttemptPayment.page.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class PayAddress extends StatefulWidget {
  final PaymentData paymentData;
  final List<String?> disabledFields;

  const PayAddress({
    Key? key,
    required this.paymentData,
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
    var appBar = PrivateAppBar(
      hasBackArrow: true,
      selectAccountEnabled: false,
      size: 160,
      backgroundColor: Brand.defaultAvatarBackground,
      color: Brand.grayDark,
      title: localizations!.translate('PAY_TO_NAME', params: {
        'name': widget.paymentData.vendor!.name,
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
              'name': userState.account!.name,
            },
          ),
          color: Brand.grayDark,
        ),
      ),
    );

    return FormPageLayout(
      appBar: appBar,
      header: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: CaptionText('FILL_PAY_FORM'),
      ),
      form: _payForm(),
      submitButton: RecActionButton(
        label: 'CONFIRM_PAYMENT',
        backgroundColor: Brand.primaryColor,
        onPressed: _isFormValid() ? _proceedWithPayment : null,
      ),
    );
  }

  Widget _payForm() {
    return PayAddressForm(
      data: widget.paymentData,
      disabledFields: widget.disabledFields,
      formKey: _formKey,
      onChange: (data) {
        setState(() => widget.paymentData.update(data!));
      },
    );
  }

  bool _isFormValid() {
    var hasConcept = Checks.isNotEmpty(widget.paymentData.concept);
    return hasConcept &&
        widget.paymentData.amount != null &&
        widget.paymentData.amount! > 0;
  }

  void _proceedWithPayment() {
    if (!_formKey.currentState!.validate()) return;

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
