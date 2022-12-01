import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rec/config/theme.dart';
import 'package:rec/config/themes/la_rosa.dart';
import 'package:rec/helpers/rec_preferences.dart';
import 'package:rec/helpers/sentry_wrapper.dart';
import 'package:rec/app.dart';
import 'package:rec/environments/env.dart';
import 'package:rec/preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'config/themes/rec.dart';
import 'environments/env.base.dart';

Future<void> main() async {
  // Loading doenv so that [Env] can be setup correctly
  await dotenv.load(fileName: "env/.env");

  // Gets the theme data for the current environment, this is done because
  // we need different themes depending on the project we are running
  final themeData = getThemeForEnv(env);

  // Additional setup
  await setup(themeData);

  // Initialize the app
  await SentryWrapper.init(env, () => runRecApp(themeData));
}

RecThemeData getThemeForEnv(RecEnvBase env) {
  switch (env.PROJECT_NAME) {
    case 'larosa':
      return laRosaTheme;
    case 'rec':
    default:
      return recTheme;
  }
}

void runRecApp(RecThemeData themeData) {
  return runApp(
    RecTheme(
      child: RecApp(),
      data: themeData,
    ),
  );
}

/// Set's up EasyLoading, RecPreferences, and other additional configurations
/// with the current theme
Future<void> setup(RecThemeData themeData) async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoading(themeData);

  await RecPreferences.initialize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  timeago.setLocaleMessages('es', timeago.EsMessages());
  timeago.setLocaleMessages('ca', timeago.CaMessages());

  Preferences.initialCameraPosition = CameraPosition(
    target: LatLng(env.MAP_CENTER_LAT, env.MAP_CENTER_LON),
    zoom: env.MAP_ZOOM,
  );
}

/// Configures EasyLoading with the current theme
void configLoading(RecThemeData themeData) {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = themeData.primaryColor
    ..backgroundColor = Colors.transparent
    ..indicatorColor = themeData.primaryColor
    ..textColor = themeData.primaryColor
    ..maskColor = Colors.white.withOpacity(0.8)
    ..textStyle = themeData.textTheme.pageTitle
    ..boxShadow = <BoxShadow>[]
    ..userInteractions = false
    ..dismissOnTap = false;
}
