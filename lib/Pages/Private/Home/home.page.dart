import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Components/Scaffold/RecNavigationBar.dart';
import 'package:rec/Pages/Private/Home/Tabs/challenges/challenges.page.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/campaign_manager.dart';
import 'package:rec/helpers/RecNavigation.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/map.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/settings.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/wallet.page.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec/preferences.dart';
import 'package:rec/config/routes.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class HomePage extends StatefulWidget {
  final bool pollUser;
  final int defaultTab;

  HomePage({
    Key? key,
    this.pollUser = true,
    this.defaultTab = 1,
  }) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  /// Method to change tabs from other widgets
  static void changeTab(BuildContext context, int tab) {
    var state = context.findAncestorStateOfType<HomePageState>()!;
    state.setCurrentTab(tab);
  }

  int? _currentTabIndex;
  UserState? _userState;
  Timer? _userPollTimer;
  CampaignProvider? _campaignProvider;
  TransactionProvider? _transactionsProvider;

  final LoginService _loginService = LoginService(env: env);
  final List<Widget> _tabs = <Widget>[
    MapPage(key: GlobalKey()),
    WalletPageRec(key: GlobalKey()),
    SettingsPage(key: GlobalKey()),
    ChallengesPage(key: GlobalKey()),
  ];

  @override
  void initState() {
    _currentTabIndex = widget.defaultTab;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _userState ??= UserState.of(context);
    _transactionsProvider ??= TransactionProvider.of(context);

    if (widget.pollUser) _userPollTimer ??= getUserTimer();

    if (_campaignProvider == null) {
      _campaignProvider = CampaignProvider.of(context);
      _campaignProvider!.load().then((value) => _checkCampaign());
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
    if (_campaignProvider!.loading) {
      return Scaffold(
        body: Center(
          child: const CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: _tabs,
      ),
      bottomNavigationBar: RecNavigationBar(
        currentTabIndex: _currentTabIndex,
        onTabTap: setCurrentTab,
      ),
    );
  }

  Timer getUserTimer() {
    return Timer.periodic(
      Preferences.userRefreshInterval,
      (_) async {
        await _refreshToken().then((value) {
          _transactionsProvider?.refresh();
          _userState!.getUser().catchError(_onGetUserError);
        });
      },
    );
  }

  Future _refreshToken() async {
    await _loginService.refreshToken(await Auth.getRefreshToken()).catchError(_refreshTokenError);
  }

  void setCurrentTab(int index) {
    setState(() => _currentTabIndex = index);
  }

  void _checkCampaign() {
    final campaignManager = CampaignManager.deaf(context);
    final definition = campaignManager.getDefinition(
      campaignManager.activeCampaignCode,
    );

    // Si no hay definition significa que no hay una camapaña activa por defecto
    // asi que podemos omitir el resto de logica
    if (definition == null) return;

    // Comprobar si se puede abrir la ficha de participar,
    // el usuario puede haber especificado que no se muestre mas
    var canBeOpened = definition.canBeOpened(context);
    if (!canBeOpened) return;

    // If the user is already participating in the campaign,
    // we don't need to show the participate page
    var isAlreadyParticipating = definition.hasAcceptedTOS(context);
    if (isAlreadyParticipating) return;

    RecNavigation.of(context).navigate(
      (c) => definition.participateBuilder(c, {}),
    );
  }

  void _refreshTokenError(err) async {
    if (err is ApiError && err.code! >= 400) {
      await RecAuth.logout(context);
      await Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }

  _onGetUserError(err) async {
    if (err is ApiError) return;
    if (err.code == 401 || err.code == 403) {
      await RecAuth.logout(context);
      await Navigator.of(context).pushReplacementNamed(Routes.login);
    }
  }
}
