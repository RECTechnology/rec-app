import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rec/Components/Info/formatted_date.dart';
import 'package:rec/Components/Inputs/RecFilterButton.dart';
import 'package:rec/Components/ListTiles/refund_list_tile.dart';
import 'package:rec/Components/Scaffold/EmptyAppBar.dart';
import 'package:rec/Components/Text/CaptionText.dart';
import 'package:rec/Components/Text/LocalizedText.dart';
import 'package:rec/Components/Text/copy_to_clipboard.dart';
import 'package:rec/Components/Wallet/transaction_icon.dart';
import 'package:rec/Components/Wallet/transaction_title.dart';
import 'package:rec/Components/Wallet/amount_widget.dart';
import 'package:rec/Components/timeline_widget.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/pay_to_address.page.dart';
import 'package:rec/config/features.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/helpers/transactions_utils.dart';
import 'package:rec/providers/app_localizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class TransactionBottomSheet extends StatefulWidget {
  static openBottomSheet(BuildContext context, Transaction tx) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white.withAlpha(100),
      barrierColor: Colors.black.withAlpha(100),
      builder: (BuildContext context) {
        return TransactionBottomSheet(tx: tx);
      },
    );
  }

  TransactionBottomSheet({
    Key? key,
    required this.tx,
  }) : super(key: key);

  final Transaction tx;

  @override
  State<TransactionBottomSheet> createState() => _TransactionBottomSheetState();
}

class _TransactionBottomSheetState extends State<TransactionBottomSheet> {
  final _transactionService = TransactionsService(env: env);

  List<Transaction> refundTxs = [];
  bool hasLoadedTxs = false;
  bool isLoadingTxs = false;
  double refundedAmount = 0;
  double get refundableAmount => tx.scaledAmount - refundedAmount;
  Transaction get tx => widget.tx;

  Future _loadRefundTxs() async {
    isLoadingTxs = true;
    refundedAmount = 0;
    refundTxs = [];

    // the current transaction has refunds and is not a refund
    // we need to load all the refund ids into transactions
    if (tx.hasRefundIds() && !tx.isRefund()) {
      for (final refundId in tx.refundsIds) {
        final refundTx = await _transactionService.getOne(
          refundId,
          tx.isIn() ? 'out' : 'in',
          env.CURRENCY_NAME,
        );
        refundTxs.add(refundTx);
        refundedAmount += refundTx.scaledAmount;
      }

      refundTxs.add(tx);
    }

    /// If the transaction is a refund, we don't need to fetch any transaction
    /// By adding the [refundParentTransaction] to the list it's enough
    else if (tx.isRefund()) {
      final parentTx = tx.refundParentTransaction as Transaction;
      final type = parentTx.isIn() ? 'out' : 'in';

      for (final refundId in parentTx.refundsIds) {
        final refundTx = await _transactionService.getOne(
          refundId,
          type,
          env.CURRENCY_NAME,
        );
        refundTxs.add(refundTx);
      }

      refundTxs.insert(0, tx.refundParentTransaction as Transaction);
    }

    setState(() {
      refundTxs.sort(TransactionHelper.sortByDate);
      isLoadingTxs = false;
    });
  }

  @override
  void didChangeDependencies() {
    if (!hasLoadedTxs) {
      _loadRefundTxs();
      hasLoadedTxs = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final recTheme = RecTheme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        primary: false,
        appBar: EmptyAppBar(
          context,
          title: 'TRANSACTION_DETAILS',
          backArrow: false,
          centerTitle: true,
          crossX: true,
          closeAction: () {
            Navigator.pop(context); // Pop the bottom modal sheet
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FormattedDate(date: tx.createdAt),
              const SizedBox(height: 16),
              _header(recTheme!),
              if (Features.refunds) _refunds(),
              Divider(indent: 24, endIndent: 24, thickness: 2, color: recTheme.separatorColor),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                child: _txInfo(recTheme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(RecThemeData theme) {
    final account = UserState.of(context).account;
    final canRefund = tx.isIn() &&
        !tx.isRefund() &&
        refundableAmount > 0 &&
        account!.isCompany() &&
        tx.paymentOrderId == null && // Don't allow refunds if tx is a payment order
        !TransactionHelper.isRecharge(widget.tx);

    final icon = TransactionIcon(widget.tx);

    return Container(
      decoration: BoxDecoration(gradient: theme.gradientGray),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Stack(
        children: [
          // Show public image if either pay in info or pay out info contains one
          if (tx.payInInfo?.publicImage != null || tx.payOutInfo?.publicImage != null)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    (tx.payInInfo?.publicImage ?? tx.payInInfo?.publicImage) as String,
                  ),
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: icon,
                ),
              ]),
              const SizedBox(height: 16),
              TransactionTitle(tx, fontSize: 18),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FancyAmountWidget(
                    amount: tx.scaledAmount,
                    isNegative: tx.isOut(),
                    styleInt: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    styleDouble: TextStyle(fontSize: 18),
                  ),
                  if (Features.refunds && canRefund && !isLoadingTxs)
                    RecFilterButton(
                      icon: Icons.outbound,
                      label: 'REFUND',
                      margin: EdgeInsets.only(right: 8),
                      onPressed: () => _goToRefundPage(theme),
                      backgroundColor: theme.redLight,
                      textColor: theme.red,
                      iconColor: theme.red,
                      elevation: 0,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _refunds() {
    /// Show a loading while loading refundTxs
    if (isLoadingTxs) {
      return Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 12, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CaptionText('LOADING_REFUNDS'),
            SizedBox(width: 12),
            SizedBox(
              child: CircularProgressIndicator(strokeWidth: 2),
              height: 24,
              width: 24,
            ),
          ],
        ),
      );
    }

    /// If there are no refund transactions, there's no need to show the timeline
    if (refundTxs.isEmpty) return SizedBox.shrink();

    return TimelineWidget(
      builder: (_, index) => RefundListTile(tx: refundTxs[index]),
      itemCount: refundTxs.length,
      currentItemIndex: refundTxs.indexWhere((c) => c.id == tx.id),
    );
  }

  Widget _txInfo(RecThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocalizedText(
          'CONCEPT',
          uppercase: true,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        _txConcept(theme),
        const SizedBox(height: 24),
        LocalizedText(
          'REFERENCE_ID',
          uppercase: true,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(
          height: 32,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _referenceID(theme),
              CopyToClipboard(
                textToCopy: tx.id.toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _txConcept(RecThemeData theme) {
    final concept = tx.getConcept()!;

    return Text(
      concept.isEmpty ? 'NO_CONCEPT' : concept,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 14,
        color: theme.grayDark,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _referenceID(RecThemeData theme) {
    return Text(
      tx.id.toString(),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 14,
        color: theme.grayDark,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  _goToRefundPage(RecThemeData theme) {
    final localizations = AppLocalizations.of(context);

    RecNavigation.navigate(context, (context) {
      return PayAddressPage(
        paymentData: PaymentData(
          txId: tx.payInInfo!.txId,
          concept: localizations!.translate(
            'REFUND_CONCEPT',
            params: {
              'previousConcept': tx.payInInfo!.concept,
            },
          ),
        ),
        buttonColor: theme.red,
        buttonTitle: 'REFUND_ACTION',
        captionText: 'REFUND_CAPTION',
        maxAmount: refundableAmount,
        title: localizations.translate('REFUND_TO_ACCOUNT', params: {
          'account': tx.payInInfo!.name,
        }),
      );
    }).then((value) {
      Navigator.popUntil(context, ModalRoute.withName(Routes.home));
    });
  }
}
