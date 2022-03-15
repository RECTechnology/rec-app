import 'package:rec/environments/env.base.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryWrapper {
  static Future<void>? init(RecEnvBase env, AppRunner appRunner) {
    if (env.SENTRY_ACTIVE == true) {
      return SentryFlutter.init(
        (options) {
          options.dsn = env.SENTRY_DSN;
          options.environment = env.ENV_NAME;
        },
        appRunner: appRunner,
      );
    }

    return appRunner() as Future<void>?;
  }
}
