import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Pages/Private/Settings/Settings.page.dart';
import 'package:rec/Pages/Private/Wallet/Wallet.page.dart';
import 'package:rec/Pages/Private/Map/Map.page.dart';
import 'package:rec/Providers/AppState.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends GenericRecViewScreen<HomePage>
    with SingleTickerProviderStateMixin {
  _HomePageState() : super(title: 'Home', hasAppBar: true);

  int currentTab = 0;
  TabController _tabController;

  Widget currentScreen = WalletPageRec();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget buildPageContent(
    BuildContext context,
    AppState appState,
    AppLocalizations localizations,
  ) {


    List<Widget> _widgetOptions = <Widget>[
      MapPage(),
      WalletPageRec(),
      SettingsPage(),
    ];

    void _onItemTapped(int index) {
      setState(() {

        currentTab = index;

      });
    }

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(currentTab),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Mapa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Billetera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuracion',
          ),
        ],
        currentIndex: currentTab,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
