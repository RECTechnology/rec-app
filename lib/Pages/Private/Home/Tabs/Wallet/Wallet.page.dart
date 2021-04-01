import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/User/UserBalance.dart';
import 'package:rec/Helpers/Formatting.dart';
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

  List<Widget> _tabs = <Widget>[
    Tab(icon: Icon(Icons.payment)),
    Tab(icon: Icon(Icons.list_alt_outlined)),
    Tab(icon: Icon(Icons.receipt)),
  ];

  List<Widget> _tabPages = [
    PayTab(),
    // Añadimos aqui el changeNotifier, porque solo lo necesita TransactionList de momento
    // Si en el futuro ahce falta en otro sitio lo podemos meter en el main, multiprovider
    ChangeNotifierProvider(
      create: (ctx) => TransactionProvider(),
      child: TransactionsList(),
    ),
    ReceiveTab(),
  ];

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
    return DefaultTabController(
      initialIndex: 1,
      length: _tabs.length,
      child: Scaffold(
        appBar: PrivateAppBar.getAppBar(
          context,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 80),
            child: Column(
              children: [UserBalance(), TabBar(tabs: _tabs)],
            ),
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: _tabPages,
        ),
      ),
    );
  }
}
