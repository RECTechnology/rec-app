import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rec/Api/RecPreferences.dart';
import 'package:rec/app.dart';
import 'package:rec/brand.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'Environments/env-local.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  await setup();

  var app = RecApp();

  if (env.SENTRY_ACTIVE) {
    return await SentryFlutter.init(
      (options) {
        options.dsn = env.SENTRY_DSN;
        options.environment = env.ENV_NAME;
      },
      appRunner: () => runApp(app),
    );
  }

  runApp(app);
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Brand.configLoading();

  await RecPreferences.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  timeago.setLocaleMessages('es', timeago.EsMessages());
}
