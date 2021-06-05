import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Components/Scaffold/RecNavigationBar.dart';
import 'package:rec/Pages/LtabCampaign/LtabInitialBanner.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/Map.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/Settings.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/Wallet.page.dart';
import 'package:rec/Providers/CampaignProvider.dart';
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
  CampaignProvider _campaignProvider;

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

    if (_campaignProvider == null) {
      _campaignProvider ??= CampaignProvider.of(context);
      _campaignProvider.load().then((value) => _checkCampaign());
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _userPollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs.elementAt(_currentTabIndex),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {
    return RecNavigationBar(
      currentTabIndex: _currentTabIndex,
      onTabTap: (int index) {
        setState(() => _currentTabIndex = index);
      },
    );
  }

  Timer getUserTimer() {
    return Timer.periodic(
      Preferences.userRefreshInterval,
      (_) {
        _users.getUser().then((value) => _userState?.setUser(value));
      },
    );
  }

  void _checkCampaign() {
    if (LtabInitialBanner.shouldBeOpenned(context)) {
      _showLtabBanner();
    }
  }

  void _showLtabBanner() {
    var activeCampaign = _campaignProvider.activeCampaign;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => LtabInitialBanner(
          activeCampaign,
        ),
      ),
    );
  }
}
