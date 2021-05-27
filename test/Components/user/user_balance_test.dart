import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/User/UserBalance.dart';
import 'package:rec/Helpers/Formatting.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('CircleAvatar with network image', (WidgetTester tester) async {
    var userBalance = UserBalance(balance: 10);

    await tester.pumpWidget(TestUtils.wrapPublicWidget(userBalance));
    await tester.pumpAndSettle();

    TestUtils.widgetExists(userBalance);
    TestUtils.isTextPresent('Saldo total');
    TestUtils.isTextPresent(
      Formatting.formatCurrency(10),
    );
  });
}
