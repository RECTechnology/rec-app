import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/Map.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/Settings.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/Wallet.page.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/preferences.dart';

class HomePage extends StatefulWidget {
  final bool pollUser;
  final int defaultTab;

  HomePage({
    Key key,
    this.pollUser = true,
    this.defaultTab = 1,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  UserState _userState;

  int _currentTabIndex;
  TabController _tabController;
  UsersService users = UsersService();
  Timer _userPollTimer;

  final List<Widget> _tabs = <Widget>[
    MapPage(),
    WalletPageRec(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.defaultTab;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _userState ??= UserState.of(context);
    if (widget.pollUser) _userPollTimer ??= getUserTimer();
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
      onTap: (int index) {
        setState(() => _currentTabIndex = index);
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _userPollTimer?.cancel();
    super.dispose();
  }

  Timer getUserTimer() {
    return Timer.periodic(
      Preferences.userRefreshInterval,
      (_) {
        users.getUser().then((value) => _userState?.setUser(value));
      },
    );
  }

  Widget buildPageContent() {
    return Scaffold(
      body: _tabs.elementAt(_currentTabIndex),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildPageContent();
  }
}
