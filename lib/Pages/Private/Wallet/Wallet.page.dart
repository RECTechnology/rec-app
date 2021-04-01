import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
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
      body: Center(
        child: Text('Estoy en la pestaña Wallet'),
      ),
    );
  }
}
