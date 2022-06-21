import 'package:rec_api_dart/rec_api_dart.dart';

abstract class RecEnvBase extends EnvBase {
  String? SENTRY_DSN;
  bool? SENTRY_ACTIVE;
  String? DEEPLINK_SCHEME;
  String? DEEPLINK_URL;

  String? CAMPAIGN_ID;

  String? LTAB_CAMPAIGN_ID;
  String? REC_CULTURAL_CAMPAIGN_ID;

  String CMP_LTAB_CODE = 'LTAB20';
  String CMP_CULT_CODE = 'CULT21';
}
