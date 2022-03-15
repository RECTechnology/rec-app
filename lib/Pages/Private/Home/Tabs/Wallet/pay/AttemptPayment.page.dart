import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rec/Components/Layout/FromToRow.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/rewarded-ltab.page.dart';
import 'package:rec/mixins/Loadable.mixin.dart';
import 'package:rec/Pages/Private/Shared/RequestPin.page.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AttemptPayment extends StatefulWidget {
  final PaymentData? data;
  final TransactionsService? transactionsService;

  const AttemptPayment({
    Key? key,
    required this.data,
    this.transactionsService,
  }) : super(key: key);

  @override
  _AttemptPaymentState createState() => _AttemptPaymentState();
}

class _AttemptPaymentState extends State<AttemptPayment> with Loadable {
  final TransactionsService _transactionsService = TransactionsService(env: env);

  TransactionsService get service =>
      widget.transactionsService ?? _transactionsService;

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var userState = UserState.of(context);

    return Scaffold(
      appBar: PrivateAppBar(
        hasBackArrow: true,
        selectAccountEnabled: false,
        size: 160,
        backgroundColor: Brand.defaultAvatarBackground,
        color: Brand.grayDark,
        title: localizations!.translate(
          'PAY_TO_NAME',
          params: {
            'name': widget.data!.vendor!.name,
          },
        ),
        textAlign: TextAlign.left,
        alignment: Alignment.centerLeft,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: UserBalance(
            balance: widget.data!.amount,
            label: localizations.translate(
              'FROM_NAME',
              params: {
                'name': userState.account!.name,
              },
            ),
            color: Brand.grayDark,
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    var localizations = AppLocalizations.of(context);
    var content = localizations!.translate('PAY_BTN');

    return RequestPin(
      buttonContent: content,
      buttonWithArrow: false,
      ifPin: _gotPin,
    );
  }

  void _gotPin(String? pin) async {
    if (isLoading) return;

    setIsLoading(true);

    widget.data!.pin = pin;

    FocusScope.of(context).requestFocus(FocusNode());

    _showCustomLoading();
    await service
        .makePayment(widget.data!)
        .then(_onPaymentOk)
        .catchError(_onPaymentError);
  }

  void _showErrorToast(error) {
    RecToast.showError(context, error.message);
  }

  void _onPaymentOk(PaymentResult paymentResult) {
    var userState = UserState.of(context, listen: false);
    var transactionProvider = TransactionProvider.of(context, listen: false);

    userState.getUser();
    transactionProvider.refresh();

    setIsLoading(false);
    Loading.dismiss();

    // LTAB
    if (paymentResult.hasBeenRewarded()) {
      var rewardedAmount = paymentResult.extraData!.rewardedLtabAmount;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => LtabRewardedPage(
            amount: (rewardedAmount! / pow(10, paymentResult.currency!.scale)),
          ),
        ),
        ModalRoute.withName(Routes.home),
      );
    } else {
      RecToast.showSuccess(context, 'PAYMENT_OK');
      Navigator.pop(context, true);
    }
  }

  void _onPaymentError(error) {
    setIsLoading(false);
    Loading.dismiss();
    _showErrorToast(error);
  }

  void _showCustomLoading() {
    var userState = UserState.of(context, listen: false);
    var localizations = AppLocalizations.of(context);

    Loading.showCustom(
      status: localizations!.translate('MAKING_PAYMENT'),
      content: FromToRow(
        from: CircleAvatarRec.fromAccount(userState.account as Account),
        to: CircleAvatarRec(imageUrl: widget.data!.vendor!.image),
      ),
    );
  }

  @override
  void setIsLoading(bool isLoading) {
    setState(() => this.isLoading = isLoading);
  }
}
