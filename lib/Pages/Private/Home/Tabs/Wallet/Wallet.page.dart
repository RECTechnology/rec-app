import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/User/UserBalance.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/Pay.tab.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/receive/Receive.tab.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/transactions/TransactionsList.tab.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';

class WalletPageRec extends StatefulWidget {
  WalletPageRec({Key key}) : super(key: key);

  @override
  _WalletPageRecState createState() => _WalletPageRecState();
}

class _WalletPageRecState extends GenericRecViewScreen<WalletPageRec> {
  _WalletPageRecState() : super(title: 'Wallet', hasAppBar: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildPageContent(
    BuildContext context,
    AppState appState,
    UserState userState,
    AppLocalizations localizations,
  ) {
    return Scaffold(
      appBar: PrivateAppBar.getAppBar(
        context,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 80),
          child: UserBalance(),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (ctx) => TransactionProvider(),
        child: TransactionsList(),
      ),
    );
  }
}
