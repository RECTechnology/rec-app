import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Wallet/UserBalance.dart';
import 'package:rec/Entities/Transactions/Currency.ent.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('CircleAvatar with network image', (WidgetTester tester) async {
    var userBalance = UserBalance(balance: 10);

    await tester.pumpWidget(TestUtils.wrapPrivateRoute(userBalance));
    await tester.pumpAndSettle();

    TestUtils.widgetExists(userBalance);
    TestUtils.isTextPresent('Saldo total');
    TestUtils.isTextPresent(
      Currency.format(10),
    );
  });
}
