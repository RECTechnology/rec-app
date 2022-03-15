import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rec/helpers/rec_preferences.dart';
import 'package:rec/helpers/sentry_wrapper.dart';
import 'package:rec/app.dart';
import 'package:rec/config/brand.dart';
import 'package:rec/environments/env.dart';
import 'package:timeago/timeago.dart' as timeago;

Future<void> main() async {
  await dotenv.load(fileName: "env/.env");
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
