import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Wallet/TransactionListTile.dart';

import '../../mocks/transactions_mock.dart';
import '../../test_utils.dart';

void main() {
  testWidgets('TransactionsListTile should build with transactionIn', (
    WidgetTester tester,
  ) async {
    var txListTile = TransactionsListTile(tx: TransactionMock.transactionIn);
    await tester.pumpWidget(
      TestUtils.wrapPublicRoute(
        ListView(
          children: [txListTile],
        ),
      ),
    );

    // Esto espera a que este todo cargado
    await tester.pumpAndSettle();

    TestUtils.widgetExists(txListTile);
    TestUtils.isTextPresent(TransactionMock.transactionIn.payInInfo.nameSender);
  });
}
