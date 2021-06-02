import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Scaffold/RecNavigationBar.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/Map.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/Settings.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/Wallet.page.dart';
import 'package:rec/Providers/UserState.dart';
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
  int _currentTabIndex;
  UserState _userState;
  Timer _userPollTimer;

  final UsersService _users = UsersService();
  final List<Widget> _tabs = <Widget>[
    MapPage(),
    WalletPageRec(),
    SettingsPage(),
  ];

  @override
  void initState() {
    _currentTabIndex = widget.defaultTab;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userState ??= UserState.of(context);
    if (widget.pollUser) _userPollTimer ??= getUserTimer();

    super.didChangeDependencies();
  }

  Widget _bottomNavigationBar() {
    return RecNavigationBar(
      currentTabIndex: _currentTabIndex,
      onTabTap: (int index) => setState(() => _currentTabIndex = index),
    );
  }

  @override
  void dispose() {
    _userPollTimer?.cancel();
    super.dispose();
  }

  Timer getUserTimer() {
    return Timer.periodic(
      Preferences.userRefreshInterval,
      (_) {
        _users.getUser().then((value) => _userState?.setUser(value));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs.elementAt(_currentTabIndex),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
