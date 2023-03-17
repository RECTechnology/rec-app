import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Components/Scaffold/RecNavigationBar.dart';
import 'package:rec/Pages/Private/Home/Tabs/challenges/challenges.page.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/app_provider.dart';
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
import 'package:rec/extensions/config_settings_app_extension.dart';

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

  /// if [skipParticipate] is true, it will not show participate modal
  static checkCampaign(BuildContext context, {bool skipParticipate = false}) {
    final campaignManager = CampaignManager.deaf(context);
    final campaignProvider = CampaignProvider.deaf(context);

    var campaignCode = campaignManager.activeCampaignCode;
    var campaign = campaignProvider.getCampaign((el) {
      return el?.code == campaignCode;
    }, orElse: () => null);

    final activeV2Campaign = campaignProvider.firstActiveV2();
    if (activeV2Campaign != null) {
      campaignCode = 'generic';
      campaign = activeV2Campaign;
    }

    final definition = campaignManager.getDefinition(campaignCode);
    // Si no hay definition significa que no hay una camapaña activa por defecto
    // asi que podemos omitir el resto de logica
    if (definition == null) return;
    // Si no existe la campaña, pasamos del tema
    if (campaign == null) return;

    final thresholdReachedCanBeOpened = definition.thresholdReachedCanBeOpened(context, campaign);
    if (thresholdReachedCanBeOpened) {
      RecNavigation.of(context).navigate(
        (c) => definition.thresholdReachedBuilder(c, {}, campaign!),
      );
      return;
    }

    // If the user is already participating in the campaign,
    // we don't need to show the participate page
    final isAlreadyParticipating = definition.hasAcceptedTOS(context, campaign);
    if (isAlreadyParticipating || skipParticipate) return;

    // Comprobar si se puede abrir la ficha de participar,
    // el usuario puede haber especificado que no se muestre mas
    final canBeOpened = definition.canBeOpened(context, campaign);
    if (!canBeOpened) return;

    RecNavigation.of(context).navigate(
      (c) => definition.participateBuilder(c, {}, campaign!),
    );
  }

  int? _currentTabIndex;
  UserState? _userState;
  Timer? _userPollTimer;
  CampaignProvider? _campaignProvider;
  TransactionProvider? _transactionsProvider;

  final LoginService _loginService = LoginService(env: env);

  final Key mapKey = GlobalKey();
  final Key walletKey = GlobalKey();
  final Key settingsKey = GlobalKey();
  final Key challengesKey = GlobalKey();

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
      _campaignProvider!.load().then((value) => checkCampaign(context));
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

    final config = AppProvider.of(context).configurationSettings;

    return Scaffold(
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          MapPage(key: mapKey),
          WalletPageRec(key: walletKey),
          if (config?.c2bEnabled == true) ChallengesPage(key: challengesKey),
          SettingsPage(key: settingsKey),
        ],
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
