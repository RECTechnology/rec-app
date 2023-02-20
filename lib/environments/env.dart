import 'dart:io';

import 'package:flutter/widgets.dart';

import 'env.base.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// This method will throw an error if dotenv is not initialized and we're
/// not in test mode
dotenvUnititialized() {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    debugPrint('Dotenv not initialized');
    return '';
  } else {
    throw Exception(
      'DotEnv not initialized, please initialize it by running "dotenv.load(<file>)"',
    );
  }
}

/// This class holds the environment variables for this project
///
/// They are loaded using the dotenv package.
///
/// There's no need to instantiate this class, prefer using `env` directly.
class Env extends RecEnvBase {
  String? CLIENT_ID = dotenv.isInitialized ? dotenv.get('CLIENT_ID') : dotenvUnititialized();
  String? CLIENT_SECRET =
      dotenv.isInitialized ? dotenv.get('CLIENT_SECRET') : dotenvUnititialized();
  String API_URL = dotenv.isInitialized ? dotenv.get('API_URL') : dotenvUnititialized();
  String? SENTRY_DSN = dotenv.isInitialized ? dotenv.get('SENTRY_DSN') : dotenvUnititialized();
  bool? SENTRY_ACTIVE = true;
  String? LTAB_CAMPAIGN_ID = '1';
  String? REC_CULTURAL_CAMPAIGN_ID = '5';
  String? DEEPLINK_SCHEME = dotenv.isInitialized ? dotenv.get('DEEPLINK_SCHEME') : 'https';
  String? DEEPLINK_URL = dotenv.isInitialized ? dotenv.get('DEEPLINK_URL') : 'rec.barcelona';
  String? RECHARGE_DEEPLINK_SCHEME =
      dotenv.isInitialized ? dotenv.get('RECHARGE_DEEPLINK_SCHEME') : 'https';
  String? RECHARGE_DEEPLINK_URL =
      dotenv.isInitialized ? dotenv.get('RECHARGE_DEEPLINK_URL') : 'rec.barcelona';
  String ENV_NAME = dotenv.isInitialized ? dotenv.get('ENV_NAME') : 'pre';
  String PROJECT_NAME = dotenv.isInitialized ? dotenv.get('PROJECT_NAME') : 'rec';
  String CURRENCY_NAME = dotenv.isInitialized ? dotenv.get('CURRENCY_NAME') : 'rec';
  String CDN_URL = dotenv.isInitialized ? dotenv.get('CDN_API_URL') : '';
  String TRANSLATIONS_PROJECT_ID =
      dotenv.isInitialized ? dotenv.get('TRANSLATIONS_PROJECT_ID') : '';

  // Map vars
  double MAP_ZOOM = double.tryParse(dotenv.get('MAP_ZOOM', fallback: '12.0')) ?? 12.0;
  double MAP_CENTER_LAT = double.tryParse(
        dotenv.get('MAP_CENTER_LAT', fallback: '41.4414534'),
      ) ??
      41.4414534;
  double MAP_CENTER_LON = double.tryParse(
        dotenv.get('MAP_CENTER_LON', fallback: '2.2086006'),
      ) ??
      2.2086006;

  bool FORCE_LOAD_FROM_CDN = false;
  bool FORCE_LOAD_FROM_LOCAL = dotenv.get('FORCE_LOAD_FROM_LOCAL', fallback: 'false') == 'true';
}

/// The current loaded environment used across the app
Env env = Env();
