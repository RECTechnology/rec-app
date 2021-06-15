import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Api/ApiError.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Api/Services/public/LoginService.dart';
import 'package:rec/Components/Scaffold/RecNavigationBar.dart';
import 'package:rec/Helpers/RecNavigation.dart';
import 'package:rec/Pages/LtabCampaign/LtabInitialBanner.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/Map.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/Settings.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/Wallet.page.dart';
import 'package:rec/Providers/CampaignProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/preferences.dart';
import 'package:rec/routes.dart';

class HomePage extends StatefulWidget {
  final bool pollUser;
  final int defaultTab;

  HomePage({
    Key key,
    this.pollUser = true,
    this.defaultTab = 1,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  /// Method to change tabs from other widgets
  static void changeTab(BuildContext context, int tab) {
    var state = context.findAncestorStateOfType<HomePageState>();
    state.setCurrentTab(tab);
  }

  int _currentTabIndex;
  UserState _userState;
  Timer _userPollTimer;
  CampaignProvider _campaignProvider;

  final UsersService _users = UsersService();
  final LoginService _loginService = LoginService();
  final List<Widget> _tabs = <Widget>[
    MapPage(key: GlobalKey()),
    WalletPageRec(key: GlobalKey()),
    SettingsPage(key: GlobalKey()),
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
      onTabTap: setCurrentTab,
    );
  }

  Timer getUserTimer() {
    return Timer.periodic(
      Preferences.userRefreshInterval,
      (_) {
        _refreshToken();
        _users
            .getUser()
            .then((value) => _userState?.setUser(value))
            .catchError(_onAuthError);
      },
    );
  }

  void _refreshToken() async {
    await _loginService.refreshToken(await Auth.getRefreshToken());
  }

  void setCurrentTab(int index) {
    setState(() => _currentTabIndex = index);
  }

  void _checkCampaign() {
    if (LtabInitialBanner.shouldBeOpenned(context)) {
      _showLtabBanner();
    }
  }

  void _showLtabBanner() {
    RecNavigation.of(context).navigate(
      (_) => LtabInitialBanner(
        _campaignProvider.activeCampaign,
      ),
    );
  }

  void _onAuthError(err) async {
    if (err is ApiError) return;
    if (err.code == 401 || err.code == 403) {
      await Auth.logout();
      await Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }
}
