import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Environments/env.base.dart';

class Deeplinking {
  static String PATH_PAY = '/pay';

  static String constructPayUrl(EnvBase env, PaymentData data) {
    return Uri(
      host: env.DEEPLINK_URL,
      scheme: env.DEEPLINK_SCHEME,
      path: PATH_PAY,
      queryParameters: data.toDeeplinkJson(),
    ).toString();
  }

  static bool matchesPaymentUri(EnvBase env, String uri) {
    var parsedUri = Uri.parse(uri);

    return parsedUri.scheme == env.DEEPLINK_SCHEME &&
        parsedUri.host == env.DEEPLINK_URL &&
        parsedUri.path == PATH_PAY;
  }
}
