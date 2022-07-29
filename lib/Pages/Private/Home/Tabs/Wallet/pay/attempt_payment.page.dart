import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rec/Components/Info/rec_circle_avatar.dart';
import 'package:rec/Components/Layout/FromToRow.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/qualifications/qualify_comerce.page.dart';
import 'package:rec/Pages/Private/Shared/RequestPin.page.dart';
import 'package:rec/Pages/Private/Shared/campaigns/ltab/rewarded-ltab.page.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecToast.dart';
import 'package:rec/helpers/loading.dart';
import 'package:rec/mixins/loadable_mixin.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/qualifications_provider.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class AttemptPayment extends StatefulWidget {
  final PaymentData data;
  final TransactionsService? transactionsService;

  /// Override the appbar title
  final String? title;

  /// optionally override the button text
  final String? buttonTitle;

  const AttemptPayment({
    Key? key,
    required this.data,
    this.transactionsService,
    this.title,
    this.buttonTitle,
  }) : super(key: key);

  @override
  _AttemptPaymentState createState() => _AttemptPaymentState();
}

class _AttemptPaymentState extends State<AttemptPayment> with Loadable {
  final TransactionsService _transactionsService = TransactionsService(env: env);

  TransactionsService get service => widget.transactionsService ?? _transactionsService;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final userState = UserState.of(context);

    return Scaffold(
      appBar: PrivateAppBar(
        hasBackArrow: true,
        selectAccountEnabled: false,
        size: 160,
        backgroundColor: Brand.defaultAvatarBackground,
        color: Brand.grayDark,
        title: widget.title ??
            localizations!.translate(
              'PAY_TO_NAME',
              params: {
                'name': widget.data.vendor!.name,
              },
            ),
        textAlign: TextAlign.left,
        alignment: Alignment.centerLeft,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: UserBalance(
            balance: widget.data.amount,
            label: localizations!.translate(
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

  @override
  void setIsLoading(bool isLoading) {
    setState(() => this.isLoading = isLoading);
  }

  Widget _body() {
    final localizations = AppLocalizations.of(context);
    final content = localizations!.translate('PAY_BTN');

    return RequestPin(
      buttonContent: widget.buttonTitle ?? content,
      buttonWithArrow: false,
      ifPin: _gotPin,
    );
  }

  Future _checkQualifications() async {
    try {
      final qualificationsProvider = QualificationsProvider.deaf(context);
      final qualifications = await qualificationsProvider.loadPending();
      Loading.dismiss();
      RecToast.showSuccess(context, 'PAYMENT_OK');

      if (qualifications.isNotEmpty) {
        return Navigator.push(
          context,
          QualifyComercePage.getRoute(
            accountToQualify: qualifications.first.account,
            qualifications: qualifications,
          ),
        );
      }

      return Future.value();
    } catch (e) {
      // If there is an error, just ignore it and proceed as normal
      Loading.dismiss();
      return Future.value();
    }
  }

  void _makePayment() async {
    if (widget.data.isRefund()) {
      await service.makeRefund(widget.data).then(_onPaymentOk).catchError(_onPaymentError);
    } else {
      await service.makePayment(widget.data).then(_onPaymentOk).catchError(_onPaymentError);
    }
  }

  void _gotPin(String? pin) async {
    if (isLoading) return;

    setIsLoading(true);

    widget.data.pin = pin;

    FocusScope.of(context).requestFocus(FocusNode());

    _showCustomLoading();
    _makePayment();
  }

  void _handleReward(PaymentResult paymentResult) {
    Loading.dismiss();
    final rewardedAmount = paymentResult.extraData!.rewardedLtabAmount;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LtabRewardedPage(
          amount: (rewardedAmount! / pow(10, paymentResult.currency!.scale)),
        ),
      ),
      ModalRoute.withName(Routes.home),
    ).then((_) => _checkQualifications());
  }

  void _onPaymentError(error) {
    setIsLoading(false);
    Loading.dismiss();
    _showErrorToast(error);
  }

  void _onPaymentOk(PaymentResult paymentResult) async {
    final userState = UserState.of(context, listen: false);
    final transactionProvider = TransactionProvider.of(context, listen: false);

    await userState.getUser();
    await transactionProvider.refresh();

    setIsLoading(false);

    /// If payment is a refund, we can pop here
    if (widget.data.isRefund()) {
      Loading.dismiss();
      Navigator.pop(context, true);
      RecToast.showSuccess(context, 'PAYMENT_OK');
      return;
    }

    if (paymentResult.hasBeenRewarded()) {
      _handleReward(paymentResult);
    } else {
      _checkQualifications().then(
        (_) => Navigator.pop(context, true),
      );
    }
  }

  void _showCustomLoading() {
    final userState = UserState.of(context, listen: false);
    final localizations = AppLocalizations.of(context);

    Loading.showCustom(
      status: localizations!.translate('MAKING_PAYMENT'),
      content: FromToRow(
        from: CircleAvatarRec.fromAccount(userState.account as Account),
        to: CircleAvatarRec(imageUrl: widget.data.vendor!.image),
      ),
    );
  }

  void _showErrorToast(error) {
    RecToast.showError(context, error.message);
  }
}
