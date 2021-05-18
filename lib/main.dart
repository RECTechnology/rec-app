import 'package:flutter/material.dart';
import 'package:rec/app.dart';
import 'package:rec/brand.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'Environments/env-local.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  await setup();

  var app = RecApp();

  if (env.SENTRY_ACTIVE) {
    await SentryFlutter.init(
      (options) => options.dsn = env.SENTRY_DSN,
      appRunner: () => runApp(app),
    );
  } else {
    runApp(app);
  }
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  timeago.setLocaleMessages('es', timeago.EsMessages());
  Brand.configLoading();
}
