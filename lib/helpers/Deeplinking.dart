import 'package:rec/environments/env.base.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class DeepLinking {
  static String PATH_PAY = '/pay';
  static String RECHARGE_PAY = '/recharge-result';

  static String constructPayUrl(RecEnvBase env, PaymentData data) {
    return Uri(
      host: env.DEEPLINK_URL,
      scheme: env.DEEPLINK_SCHEME,
      path: PATH_PAY,
      queryParameters: data.toDeeplinkJson(),
    ).toString();
  }

  static bool matchesPaymentUri(RecEnvBase env, String uri) {
    var parsedUri = Uri.parse(uri);

    return parsedUri.scheme == env.DEEPLINK_SCHEME &&
        parsedUri.host == env.DEEPLINK_URL &&
        parsedUri.path == PATH_PAY;
  }

  static bool matchesRechargeResultUri(RecEnvBase env, uri) {
    var parsedUri = Uri.parse(uri);

    return parsedUri.scheme == env.RECHARGE_DEEPLINK_SCHEME &&
        parsedUri.host == env.RECHARGE_DEEPLINK_URL &&
        parsedUri.path == RECHARGE_PAY;
  }
}
