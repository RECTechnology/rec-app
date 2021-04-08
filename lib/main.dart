import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Auth.dart';
import 'package:rec/Api/Services/AppService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Providers/UserState.dart';
import 'package:rec/app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'Environments/env-local.dart';
import 'Providers/AppState.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  timeago.setLocaleMessages('es', timeago.EsMessages());

  await AppService().getAppToken();

  var _storage = RecStorage();
  var savedUser = await UserState.getSavedUser(_storage);
  var token = await Auth.getAccessToken();
  var packageInfo = await PackageInfo.fromPlatform();

  var appProvided = MultiProvider(
    providers: [
      AppState.getProvider(packageInfo),
      UserState.getProvider(_storage, savedUser),
    ],
    child: RecApp(token),
  );

  if (env.SENTRY_ACTIVE) {
    await SentryFlutter.init(
      (options) => options.dsn = env.SENTRY_DSN,
      appRunner: () => runApp(appProvided),
    );
  } else {
    runApp(appProvided);
  }
}
