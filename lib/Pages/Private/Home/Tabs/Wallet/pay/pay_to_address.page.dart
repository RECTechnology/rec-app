import 'package:flutter/material.dart';
import 'package:rec/Components/Forms/PayAddress.form.dart';
import 'package:rec/Components/Inputs/RecActionButton.dart';
import 'package:rec/Components/Layout/FormPageLayout.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/attempt_payment.page.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class PayAddressPage extends StatefulWidget {
  final PaymentData paymentData;
  final List<String?> disabledFields;

  /// Override the appbar title
  final String? title;

  /// optionally override the button text
  final String? buttonTitle;

  /// optionally override the caption text
  final String? captionText;

  /// optional color for the button
  final Color? buttonColor;

  /// Maximum amount that can be paid
  ///
  /// This is used for refunds for now, this way we can limit the amount
  final double? maxAmount;

  const PayAddressPage({
    Key? key,
    required this.paymentData,
    this.disabledFields = const [],
    this.title,
    this.buttonTitle,
    this.maxAmount,
    this.captionText,
    this.buttonColor,
  }) : super(key: key);

  @override
  _PayAddressPageState createState() => _PayAddressPageState();
}

class _PayAddressPageState extends State<PayAddressPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return _content();
  }

  Widget _content() {
    final localizations = AppLocalizations.of(context);
    final userState = UserState.of(context);
    final appBar = PrivateAppBar(
      hasBackArrow: true,
      selectAccountEnabled: false,
      size: 160,
      backgroundColor: Brand.defaultAvatarBackground,
      color: Brand.grayDark,
      title: widget.title ??
          localizations!.translate('PAY_TO_NAME', params: {
            'name': widget.paymentData.vendor!.name,
          }),
      textAlign: TextAlign.left,
      alignment: Alignment.centerLeft,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: UserBalance(
          balance: widget.paymentData.amount,
          label: localizations!.translate(
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
        child: CaptionText(widget.captionText ?? 'FILL_PAY_FORM'),
      ),
      form: _payForm(),
      submitButton: RecActionButton(
        label: widget.buttonTitle ?? 'CONFIRM_PAYMENT',
        backgroundColor: widget.buttonColor ?? Brand.primaryColor,
        onPressed: _isFormValid() ? _proceedWithPayment : null,
      ),
    );
  }

  Widget _payForm() {
    return PayAddressForm(
      data: widget.paymentData,
      disabledFields: widget.disabledFields,
      maxAmount: widget.maxAmount,
      formKey: _formKey,
      onChange: (data) {
        setState(() => widget.paymentData.update(data!));
      },
      onValidate: () => _formKey.currentState!.validate(),
    );
  }

  bool _isFormValid() {
    final hasConcept = Checks.isNotEmpty(widget.paymentData.concept);

    return hasConcept && widget.paymentData.amount != null && widget.paymentData.amount! > 0;
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
