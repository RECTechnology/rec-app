import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Base/screens/GenericRecViewScreen.dart';
import 'package:rec/Components/Scaffold/PrivateAppBar.dart';
import 'package:rec/Lang/AppLocalizations.dart';
import 'package:rec/Pages/Private/Settings/Settings.page.dart';
import 'package:rec/Pages/Private/Wallet/Wallet.page.dart';
import 'package:rec/Pages/Private/Map/Map.page.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends GenericRecViewScreen<HomePage>
    with SingleTickerProviderStateMixin {
  _HomePageState() : super(title: 'Home', hasAppBar: true);

  int _currentTabIndex = 1;
  TabController _tabController;

  final List<Widget> _tabs = <Widget>[
    MapPage(),
    WalletPageRec(),
    SettingsPage(),
  ];

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

  void _onItemTapped(int index) {
    setState(() => _currentTabIndex = index);
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Mapa',
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
      currentIndex: _currentTabIndex,
      selectedItemColor: Brand.primaryColor,
      onTap: _onItemTapped,
    );
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
        child: _tabs.elementAt(_currentTabIndex),
      ),
      appBar: PrivateAppBar.getAppBar(context),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
