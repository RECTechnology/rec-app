import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Environments/env.dart';
import 'package:rec/Helpers/Deeplinking.dart';

void main() {
  test('Deeplinking.constructPayUrl works', () async {
    var env = Env();
    var payData = PaymentData(address: 'address', amount: 0);
    var payUrl = Deeplinking.constructPayUrl(env, payData);

    expect(
      payUrl,
      '${env.DEEPLINK_SCHEME}://${env.DEEPLINK_URL}${Deeplinking.PATH_PAY}?amount=0.0&address=address',
    );
  });

  test('Deeplinking.constructPayUrl works with custom data', () async {
    var env = Env();
    var payData = PaymentData(address: 'test', amount: 0);
    var payUrl = Deeplinking.constructPayUrl(env, payData);

    expect(
      payUrl,
      '${env.DEEPLINK_SCHEME}://${env.DEEPLINK_URL}${Deeplinking.PATH_PAY}?amount=0.0&address=test',
    );
  });

  test('Deeplinking.matchesPaymentUri works for correct Deeplinking Pay link',
      () async {
    var env = Env();
    var payUrl = Deeplinking.matchesPaymentUri(
      env,
      '${env.DEEPLINK_SCHEME}://${env.DEEPLINK_URL}${Deeplinking.PATH_PAY}',
    );
    expect(payUrl, true);
  });

  test('Deeplinking.matchesPaymentUri works for incorrect Deeplinking Pay link',
      () async {
    var env = Env();

    expect(
      Deeplinking.matchesPaymentUri(
        env,
        'badscheme://${env.DEEPLINK_URL}${Deeplinking.PATH_PAY}',
      ),
      false,
    );
    expect(
      Deeplinking.matchesPaymentUri(
        env,
        '${env.DEEPLINK_SCHEME}://bad.url${Deeplinking.PATH_PAY}',
      ),
      false,
    );
    expect(
      Deeplinking.matchesPaymentUri(
        env,
        'badscheme://${env.DEEPLINK_URL}/bad-path',
      ),
      false,
    );
  });

  test('Deeplink.matchesRechargeResult', () {
    var env = Env();
    var matches = Deeplinking.matchesRechargeResultUri(
      env,
      'https://rec.barcelona/recharge-result?status=ok',
    );

    expect(matches, true);
  });
}
