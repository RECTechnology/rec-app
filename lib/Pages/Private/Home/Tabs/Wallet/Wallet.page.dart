import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/User/UserBalance.dart';
import 'package:rec/Components/Wallet/WalletFloatingActions.dart';
import 'package:rec/Entities/Currency.ent.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/transactions/TransactionsList.tab.dart';
import 'package:rec/Providers/UserState.dart';

class WalletPageRec extends StatefulWidget {
  final bool autoReloadEnabled;

  WalletPageRec({
    Key key,
    this.autoReloadEnabled = true,
  }) : super(key: key);

  @override
  _WalletPageRecState createState() => _WalletPageRecState();
}

class _WalletPageRecState extends State<WalletPageRec> {
  @override
  Widget build(BuildContext context) {
    var userState = UserState.of(context);
    return Scaffold(
      appBar: PrivateAppBar(
        size: 160,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: UserBalance(
            balance: userState.account
                ?.getWalletByCurrency(Currency.rec)
                ?.getScaledBalance(),
          ),
        ),
      ),
      floatingActionButton: WalletFloatingActions(),
      body: TransactionsList(
        autoReloadEnabled: widget.autoReloadEnabled,
      ),
    );
  }
}
