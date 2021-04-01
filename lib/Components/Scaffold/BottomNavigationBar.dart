import 'package:flutter/material.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/Map.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/Settings.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/Wallet.page.dart';
import 'package:rec/brand.dart';

class RecBottomNavigationBar extends StatefulWidget {
  final TabController _tabController;
  RecBottomNavigationBar(this._tabController);

  @override
  State<StatefulWidget> createState() {
    return _RecBottomNavigationBar();
  }
}

class _RecBottomNavigationBar extends State<RecBottomNavigationBar> {
  int _currentTabIndex = 1;
  TabController _tabController;

  final List<Widget> _tabs = <Widget>[
    MapPage(),
    WalletPageRec(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() => _currentTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
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
}
