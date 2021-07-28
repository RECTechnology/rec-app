import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:rec/Api/Services/wallet/TransactionsService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Providers/All.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class RecApp extends StatefulWidget {
  @override
  _RecAppState createState() => _RecAppState();

  static final RecSecureStorage _storage = RecSecureStorage();

  static void setLocale(BuildContext context, Locale locale) {
    var state = context.findAncestorStateOfType<_RecAppState>();

    // ignore: invalid_use_of_protected_member
    state.setState(() {
      state.locale = locale;
    });
    _storage.write(
      key: 'locale',
      value: locale.languageCode,
    );
  }

  static Future<Locale> restoreLocale() async {
    var savedLocale = await _storage.read(
      key: 'locale',
    );

    return AppLocalizations.getLocaleByLanguageCode(savedLocale);
  }
}

class _RecAppState extends State<RecApp> {
  final RecSecureStorage storage = RecSecureStorage();
  final TransactionsService txService = TransactionsService();

  Locale locale;
  List<SingleChildWidget> _providers;

  @override
  void initState() {
    _setup();
    super.initState();
  }

  Future _setup() async {
    locale = await RecApp.restoreLocale();

    var providers = await getProviders();
    setState(() => _providers = providers);
  }

  Future<List<SingleChildWidget>> getProviders() async {
    var savedUser = await UserState.getSavedUser(storage);
    var packageInfo = await PackageInfo.fromPlatform();

    var prefProvider = PreferenceProvider.getProvider(
      preferences: PreferenceDefinitions.all,
      groups: [
        PreferenceDefinitions.general,
      ],
    );

    return [
      AppState.getProvider(packageInfo),
      UserState.getProvider(storage, savedUser),
      TransactionProvider.getProvider(txService),
      DocumentsProvider.getProvider(),
      CampaignProvider.getProvider(),
      prefProvider,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Checks.isNotEmpty(_providers)
        ? _buildAppWithProviders(_providers)
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Widget _buildAppWithProviders(
    List<SingleChildWidget> providers,
  ) {
    var app = MaterialApp(
      title: Brand.appName,
      locale: locale,
      theme: Brand.createTheme(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: AppLocalizations.localeResolutionCallback,
      builder: EasyLoading.init(),
      initialRoute: Routes.home,
      routes: ROUTES,
      onGenerateRoute: Routes.onGenerateRoute,
    );

    return MultiProvider(
      providers: providers,
      child: app,
    );
  }
}
