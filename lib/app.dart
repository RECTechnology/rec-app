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

  static void setLocale(BuildContext context, Locale locale) {
    var state = context.findAncestorStateOfType<_RecAppState>();

    // ignore: invalid_use_of_protected_member
    state.setState(() {
      state.locale = locale;
    });
  }
}

class _RecAppState extends State<RecApp> {
  final RecSecureStorage storage = RecSecureStorage();
  final TransactionsService txService = TransactionsService();

  Locale locale;
  List<SingleChildWidget> providers;

  @override
  void initState() {
    getProviders().then((value) {
      setState(() => providers = value);
    });
    super.initState();
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
    return Checks.isNotEmpty(providers)
        ? _buildAppWithProviders(providers)
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
