import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Wallet/user_balance.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('UserBalance build correctly', (tester) async {
    await tester.runAsync(() async {
      var userBalance = UserBalance(balance: 10);

      await tester.pumpWidget(await TestUtils.wrapPrivateRoute(userBalance));
      await tester.pumpAndSettle();

      TestUtils.widgetExists(userBalance);
      TestUtils.isTextPresent('Saldo total');
      TestUtils.isTextPresent(
        Currency.format(10),
      );
    });
  });
}
