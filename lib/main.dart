import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rec/Api/RecPreferences.dart';
import 'package:rec/Helpers/sentry_wrapper.dart';
import 'package:rec/app.dart';
import 'package:rec/brand.dart';
import 'Environments/env-local.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  await setup();
  await SentryWrapper.init(env, runRecApp);
}

void runRecApp() {
  return runApp(RecApp());
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
