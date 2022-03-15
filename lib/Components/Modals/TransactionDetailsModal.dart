import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec/Components/Info/CircleAvatar.dart';
import 'package:rec/Components/Info/InfoColumn.dart';
import 'package:rec/Components/Wallet/Transactions/TransactionAmount.dart';
import 'package:rec/Components/Wallet/Transactions/TransactionIcon.dart';
import 'package:rec/Components/Wallet/Transactions/TransactionTitle.dart';
import 'package:rec/providers/AppLocalizations.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/styles/box_decorations.dart';
import 'package:rec/config/brand.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class TransactionDetailsModal {
  final BuildContext context;
  TransactionDetailsModal(this.context);

  void open(Transaction transaction) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Container(
          decoration: BoxDecorations.transparentBorder(),
          height: MediaQuery.of(context).size.height * 0.55,
          child: _dialogContent(transaction),
        ),
      ),
    );
  }

  Widget _dialogContent(Transaction transaction) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _txDetailsBody(transaction),
    );
  }

  Widget _txDetailsBody(Transaction transaction) {
    return Column(
      children: [
        _txHeader(transaction),
        _txDate(transaction),
        Flexible(
          child: ListView(
            children: [
              _txCard(transaction),
              _txDetails(transaction),
            ],
          ),
        ),
      ],
    );
  }

  Widget _txHeader(Transaction transaction) {
    var userState = UserState.of(context);
    var selfAccount = userState.account;
    var otherAccount = TransactionIcon(transaction);

    var selfImage = Container(
      width: 64,
      height: 64,
      child: CircleAvatarRec.fromAccount(selfAccount!),
    );
    var otherImage = Container(
      width: 64,
      height: 64,
      child: otherAccount,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          transaction.isOut() ? selfImage : otherImage,
          Icon(
            Icons.east,
            color: Brand.grayLight2,
          ),
          transaction.isOut() ? otherImage : selfImage,
        ],
      ),
    );
  }

  Widget _txDate(Transaction transaction) {
    var localizations = AppLocalizations.of(context);
    var dateString = DateFormat('d MMMM yyyy  HH:mm', localizations!.locale.languageCode)
        .format(transaction.createdAt.toLocal());

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Text(
          dateString,
          style: TextStyle(
            color: Brand.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _txConcept(Transaction transaction) {
    var localizations = AppLocalizations.of(context);
    var concept = transaction.getConcept()!;

    return Text(
      localizations!.translate(concept.isEmpty ? 'NO_CONCEPT' : concept),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 18,
        color: Brand.grayDark2,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _txCard(Transaction transaction) {
    return Container(
      decoration: BoxDecorations.solid(Brand.defaultAvatarBackground),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TransactionTitle(transaction, fontSize: 18),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TransactionAmount(
                transaction,
                fontSize: 18,
              ),
            ),
            _txConcept(transaction),
          ],
        ),
      ),
    );
  }

  Widget _txDetails(Transaction transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoColumn(label: 'TX_ID', value: transaction.id ?? ''),
          InfoColumn(
            label: 'TX_STATUS',
            value: 'STATUS_${transaction.status!.toUpperCase()}',
          ),
        ],
      ),
    );
  }
}
