import 'package:rec_api_dart/rec_api_dart.dart';

abstract class RecEnvBase extends EnvBase {
  /// The sentry dsn url, you should get this from Sentry,
  /// or ask some of the QbitArtifacts developers
  String? SENTRY_DSN;

  /// Whether sentry should be enabled in the project or not
  bool? SENTRY_ACTIVE;

  /// What scheme should deeplinking use
  String? DEEPLINK_SCHEME;

  /// Deepling url
  String? DEEPLINK_URL;

  /// LTAB Campaign id
  String? LTAB_CAMPAIGN_ID;

  /// CULTURE Campaign id
  String? REC_CULTURAL_CAMPAIGN_ID;

  /// LTAB Campaign code
  String CMP_LTAB_CODE = 'LTAB20';

  /// CULTURE Campaign code
  String CMP_CULT_CODE = 'CULT21';

  /// The name of this environment
  abstract String ENV_NAME;

  /// The name of this whitelabel instance project
  abstract String PROJECT_NAME;

  abstract String CDN_URL;
  abstract String TRANSLATIONS_PROJECT_ID;
}
