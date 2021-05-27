import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Services/wallet/TransactionsService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:rec/Providers/AppLocalizations.dart';
import 'package:rec/Providers/AppState.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/brand.dart';
import 'package:rec/routes.dart';

class RecApp extends StatefulWidget {
  @override
  _RecAppState createState() => _RecAppState();
}

class _RecAppState extends State<RecApp> {
  final RecStorage storage = RecStorage();
  final TransactionsService txService = TransactionsService();

  User savedUser;
  PackageInfo packageInfo;

  Future _setUp() async {
    savedUser = await UserState.getSavedUser(storage);
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _setUp(),
      builder: (ctx, snapshot) => _buildAppWithProviders(snapshot),
    );
  }

  Widget _buildAppWithProviders(snapshot) {
    var app = MaterialApp(
      title: Brand.appName,
      theme: Brand.createTheme(),
      locale: Locale('es_ES'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      localeResolutionCallback: AppLocalizations.localeResolutionCallback,
      builder: EasyLoading.init(),
      initialRoute: Routes.home,
      routes: ROUTES,
      onGenerateRoute: Routes.onGenerateRoute,
    );

    var appProvided = MultiProvider(
      providers: [
        AppState.getProvider(packageInfo),
        UserState.getProvider(storage, savedUser),
        TransactionProvider.getProvider(txService),
      ],
      child: app,
    );

    return appProvided;
  }
}
