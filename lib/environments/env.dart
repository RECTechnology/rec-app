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
  @override
  String? CLIENT_ID = dotenv.isInitialized ? dotenv.get('CLIENT_ID') : dotenvUnititialized();

  @override
  String? CLIENT_SECRET =
      dotenv.isInitialized ? dotenv.get('CLIENT_SECRET') : dotenvUnititialized();

  @override
  String API_URL = dotenv.isInitialized ? dotenv.get('API_URL') : dotenvUnititialized();

  @override
  String? SENTRY_DSN = dotenv.isInitialized ? dotenv.get('SENTRY_DSN') : dotenvUnititialized();

  @override
  bool? SENTRY_ACTIVE = true;

  @override
  String? LTAB_CAMPAIGN_ID = '1';

  @override
  String? REC_CULTURAL_CAMPAIGN_ID = '5';

  @override
  String? DEEPLINK_SCHEME = 'https';

  @override
  String? DEEPLINK_URL = 'rec.barcelona';

  @override
  String ENV_NAME = dotenv.isInitialized ? dotenv.get('ENV_NAME') : 'pre';

  @override
  String PROJECT_NAME = dotenv.isInitialized ? dotenv.get('PROJECT_NAME') : 'rec';

  String CDN_URL = dotenv.isInitialized ? dotenv.get('CDN_API_URL') : '';
  String TRANSLATIONS_PROJECT_ID =
      dotenv.isInitialized ? dotenv.get('TRANSLATIONS_PROJECT_ID') : '';
}

/// The current loaded environment used across the app
Env env = Env();
