// Enviroment file

import 'env.base.dart';

class Env implements EnvBase {
  @override
  String CLIENT_ID = '1_23zebs1ciqsk088s4wckckgwkcogo8ws8os48osc40s0s8ss0k';
  @override
  String CLIENT_SECRET = '2zspa4vc6ask0wk0kcso0sowg0w088k00k00gkcs8ggs0g400g';
  @override
  String API_URL = 'api.rec.qbitartifacts.com';
  @override
  String SENTRY_DSN =
      'https://7e56fd98698040dcbf7f6820c37fa786@o285450.ingest.sentry.io/5525186';
  @override
  bool SENTRY_ACTIVE = true;
  @override
  String CAMPAIGN_ID = '1';

  @override
  String DEEPLINK_SCHEME = 'app';
  @override
  String DEEPLINK_URL = 'rec.barcelona';
}

Env env = Env();
