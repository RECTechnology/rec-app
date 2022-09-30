import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ListTiles/TransactionListTile.dart';

import '../../mocks/transactions_mock.dart';
import '../../test_utils.dart';

void main() {
  testWidgets('TransactionsListTile should build with transactionOut', (
    WidgetTester tester,
  ) async {
    var txListTile = TransactionsListTile(tx: TransactionMock.transactionOut);
    await tester.pumpWidget(
      await TestUtils.wrapPublicRoute(
        ListView(
          children: [txListTile],
        ),
      ),
    );

    // Esto espera a que este todo cargado
    await tester.pumpAndSettle();

    TestUtils.widgetExists(txListTile);
    TestUtils.isTextPresent(
      TransactionMock.transactionOut.payOutInfo!.name!,
    );
  });
}
