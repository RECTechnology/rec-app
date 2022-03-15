import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Wallet/Transactions/TransactionAmount.dart';

import '../../mocks/transactions_mock.dart';
import '../../test_utils.dart';

void main() {
  testWidgets('TransactionAmount should build with transactionIn', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      var txAmount = TransactionAmount(
        TransactionMock.transactionIn..scaledAmount = 3,
      );

      await tester.pumpWidget(
        TestUtils.wrapPublicRoute(txAmount),
      );

      // Esto espera a que este todo cargado
      await tester.pumpAndSettle();

      TestUtils.widgetExists(txAmount);
      TestUtils.isTextPresent('+3.00 R');
    });
  });

  testWidgets('TransactionAmount should build with transactionOut', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      var txAmount = TransactionAmount(
        TransactionMock.transactionOut..scaledAmount = 3,
      );

      await tester.pumpWidget(
        TestUtils.wrapPublicRoute(txAmount),
      );

      // Esto espera a que este todo cargado
      await tester.pumpAndSettle();

      TestUtils.widgetExists(txAmount);
      TestUtils.isTextPresent('-3.00 R');
    });
  });

  testWidgets('TransactionAmount should build with transactionRecharge', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      var txAmount = TransactionAmount(
        TransactionMock.transactionRecharge..scaledAmount = 3,
      );

      await tester.pumpWidget(
        TestUtils.wrapPublicRoute(txAmount),
      );

      // Esto espera a que este todo cargado
      await tester.pumpAndSettle();

      TestUtils.widgetExists(txAmount);
      TestUtils.isTextPresent('+3.00 R');
    });
  });
}
