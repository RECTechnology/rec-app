import 'env.base.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env extends RecEnvBase {
  @override
  String? CLIENT_ID = dotenv.isInitialized ? dotenv.get('CLIENT_ID') : '';

  @override
  String? CLIENT_SECRET = dotenv.isInitialized ? dotenv.get('CLIENT_SECRET') : '';

  @override
  String? API_URL = dotenv.isInitialized ? dotenv.get('API_URL') : '';

  @override
  String? SENTRY_DSN = dotenv.isInitialized ? dotenv.get('SENTRY_DSN') : '';

  @override
  bool? SENTRY_ACTIVE = true;

  @override
  String? CAMPAIGN_ID = '1';

  @override
  String? LTAB_CAMPAIGN_ID = '1';

  @override
  String? REC_CULTURAL_CAMPAIGN_ID = '5';

  @override
  String? DEEPLINK_SCHEME = 'https';

  @override
  String? DEEPLINK_URL = 'rec.barcelona';

  @override
  String ENV_NAME = 'pre';
}

Env env = Env();
