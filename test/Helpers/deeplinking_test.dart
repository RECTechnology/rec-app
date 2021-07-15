import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Environments/env.dart';
import 'package:rec/Helpers/Deeplinking.dart';

void main() {
  test('DeepLinking.constructPayUrl works', () async {
    var env = Env();
    var payData = PaymentData(address: 'address', amount: 0);
    var payUrl = DeepLinking.constructPayUrl(env, payData);

    expect(
      payUrl,
      '${env.DEEPLINK_SCHEME}://${env.DEEPLINK_URL}${DeepLinking.PATH_PAY}?amount=0.0&address=address',
    );
  });

  test('Deeplinking.constructPayUrl works with custom data', () async {
    var env = Env();
    var payData = PaymentData(address: 'test', amount: 0);
    var payUrl = DeepLinking.constructPayUrl(env, payData);

    expect(
      payUrl,
      '${env.DEEPLINK_SCHEME}://${env.DEEPLINK_URL}${DeepLinking.PATH_PAY}?amount=0.0&address=test',
    );
  });

  test('Deeplinking.matchesPaymentUri works for correct Deeplinking Pay link',
      () async {
    var env = Env();
    var payUrl = DeepLinking.matchesPaymentUri(
      env,
      '${env.DEEPLINK_SCHEME}://${env.DEEPLINK_URL}${DeepLinking.PATH_PAY}',
    );
    expect(payUrl, true);
  });

  test('Deeplinking.matchesPaymentUri works for incorrect Deeplinking Pay link',
      () async {
    var env = Env();

    expect(
      DeepLinking.matchesPaymentUri(
        env,
        'badscheme://${env.DEEPLINK_URL}${DeepLinking.PATH_PAY}',
      ),
      false,
    );
    expect(
      DeepLinking.matchesPaymentUri(
        env,
        '${env.DEEPLINK_SCHEME}://bad.url${DeepLinking.PATH_PAY}',
      ),
      false,
    );
    expect(
      DeepLinking.matchesPaymentUri(
        env,
        'badscheme://${env.DEEPLINK_URL}/bad-path',
      ),
      false,
    );
  });

  test('Deeplink.matchesRechargeResult', () {
    var env = Env();
    var matches = DeepLinking.matchesRechargeResultUri(
      env,
      'https://rec.barcelona/recharge-result?status=ok',
    );

    expect(matches, true);
  });
}
