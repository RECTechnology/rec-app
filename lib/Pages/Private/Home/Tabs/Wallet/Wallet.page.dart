import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Components/User/UserBalance.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/transactions/TransactionsList.tab.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class WalletPageRec extends StatefulWidget {
  WalletPageRec({Key key}) : super(key: key);

  @override
  _WalletPageRecState createState() => _WalletPageRecState();
}

class _WalletPageRecState extends GenericRecViewScreen<WalletPageRec> {
  _WalletPageRecState() : super(title: 'Wallet', hasAppBar: true);
  TextStyle labelStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w300,
    color: Brand.grayDark,
  );
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
      floatingActionButton: buildSpeedDial(),
      body: ChangeNotifierProvider(
        create: (ctx) => TransactionProvider(),
        child: TransactionsList(),
      ),
    );
  }

  SpeedDial buildSpeedDial() {
    var userState = UserState.of(context);
    var accountTypeColor =
        Brand.getColorForAccount(userState.user.selectedAccount);

    return SpeedDial(
      marginEnd: 20,
      marginBottom: 20,
      animationSpeed: 150,
      icon: Icons.multiple_stop,
      activeIcon: Icons.multiple_stop,
      iconTheme: IconThemeData(color: Colors.white, size: 30),
      visible: true,
      curve: Curves.linear,
      overlayColor: Colors.white,
      overlayOpacity: 0.8,
      backgroundColor: accountTypeColor,
      foregroundColor: Colors.white,
      elevation: 0,
      children: [
        buildSpeedDialChild(
          'PAY_QR',
          Icons.qr_code_scanner,
          bgColor: accountTypeColor,
        ),
        buildSpeedDialChild(
          'PAY_ACCOUNT_CONTACT',
          Icons.call_made,
          bgColor: accountTypeColor,
        ),
        buildSpeedDialChild(
          'RECEIVE_PAYMENT',
          Icons.call_received,
          bgColor: accountTypeColor,
        ),
        buildSpeedDialChild(
          'RECHARGE_RECS',
          Icons.credit_card,
          iconColor: Brand.grayDark,
          bgColor: Brand.defaultAvatarBackground,
        ),
      ],
    );
  }

  SpeedDialChild buildSpeedDialChild(
    String label,
    IconData icon, {
    Color bgColor = Brand.primaryColor,
    Color iconColor = Colors.white,
  }) {
    var localization = AppLocalizations.of(context);

    return SpeedDialChild(
      child: Icon(
        icon,
        color: iconColor,
      ),
      backgroundColor: bgColor,
      labelWidget: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Text(
          localization.translate(label),
          style: labelStyle,
        ),
      ),
      elevation: 0,
      onTap: () => print('PaY_QR'),
      onLongPress: () => print('FIRST CHILD LONG PRESS'),
    );
  }
}
