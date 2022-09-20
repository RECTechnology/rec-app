import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rec/config/campaign_definitions.dart';
import 'package:rec/config/routes.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/providers/All.dart';
import 'package:rec/providers/activity_provider.dart';
import 'package:rec/providers/badges_provider.dart';
import 'package:rec/providers/campaign_manager.dart';
import 'package:rec/providers/qualifications_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Entry point widget for the REC app
class RecApp extends StatefulWidget {
  static final IStorage _storage = RecSecureStorage();

  @override
  _RecAppState createState() => _RecAppState();

  /// Used to change locale from anywhere and re-build the widget tree
  static Future<Locale> restoreLocale() async {
    var savedLocale = await (_storage.read(key: 'locale'));
    if (savedLocale == null) return AppLocalizations.supportedLocales[0];

    return AppLocalizations.getLocaleByLanguageCode(savedLocale);
  }

  /// Set the current locale
  static void setLocale(BuildContext context, Locale locale) {
    var state = context.findAncestorStateOfType<_RecAppState>()!;

    // ignore: invalid_use_of_protected_member
    state.setState(() {
      state.locale = locale;
    });
    _storage.write(
      key: 'locale',
      value: locale.languageCode,
    );
  }
}

class _RecAppState extends State<RecApp> {
  final txService = TransactionsService(env: env);
  final activitiesService = ActivitiesService(env: env);
  final qualificationsService = QualificationsService(env: env);
  final appService = AppService(env: env);
  final badgesService = BadgesService(env: env);

  late IStorage storage;
  Locale? locale;
  List<SingleChildWidget>? _providers;

  @override
  void initState() {
    _setup();
    super.initState();
  }

  /// Initial setup, loads providers and locale
  Future _setup() async {
    storage = RecSecureStorage();
    locale = await RecApp.restoreLocale();

    var providers = await getProviders();
    setState(() => _providers = providers);
  }

  @override
  Widget build(BuildContext context) {
    return Checks.isNotEmpty(_providers)
        ? _buildAppWithProviders(_providers!)
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  /// Returns the list of providers needed in the app
  Future<List<SingleChildWidget>> getProviders() async {
    final savedUser = await UserState.getSavedUser(storage);
    final packageInfo = await PackageInfo.fromPlatform();
    final prefProvider = PreferenceProvider.getProvider(
      preferences: PreferenceDefinitions.all,
      groups: [
        PreferenceDefinitions.general,
      ],
    );

    return [
      AppProvider.getProvider(packageInfo, appService),
      ActivityProvider.getProvider(activitiesService),
      BadgesProvider.getProvider(badgesService),
      UserState.getProvider(storage, savedUser),
      TransactionProvider.getProvider(txService),
      QualificationsProvider.getProvider(qualificationsService),
      CampaignManager.getProvider(
        definitions: getCampaignDefinitions(),
        activeCampaignCode: env.CMP_CULT_CODE,
      ),
      DocumentsProvider.getProvider(),
      CampaignProvider.getProvider(),
      prefProvider,
    ];
  }

  /// Build the MaterialApp and also adds all the providers to the widget tree
  Widget _buildAppWithProviders(List<SingleChildWidget> providers) {
    final recTheme = RecTheme.of(context);

    final app = MaterialApp(
      title: env.PROJECT_NAME,
      theme: recTheme!.getThemeData(),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: AppLocalizations.localeResolutionCallback,
      builder: EasyLoading.init(),
      initialRoute: Routes.init,
      routes: ROUTES,
      onGenerateRoute: Routes.onGenerateRoute,
      navigatorObservers: [
        SentryNavigatorObserver(),
      ],
    );

    // TODO: Most providers are not required until user is logged in,
    // so we can move then into [HomePage], this will clear up the widget tree in the public part of the app
    // The only required provider is AppState, and UserState, the other provider are not needed here
    return MultiProvider(
      providers: providers,
      child: app,
    );
  }
}
