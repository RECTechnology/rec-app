import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Wallet/transaction_title.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

import '../../mocks/storage_mock.dart';
import '../../mocks/transactions_mock.dart';
import '../../mocks/users_mock.dart';
import '../../test_utils.dart';

void main() {
  expectTxTitleToBe({
    required WidgetTester tester,
    required Transaction transaction,
    required String expectedTitle,
    UserState? state,
  }) async {
    final title = TransactionTitle(transaction);
    await tester.pumpWidget(
      await TestUtils.wrapPrivateRoute(title, userState: state),
    );

    // Esto espera a que este todo cargado
    await tester.pumpAndSettle();
    TestUtils.widgetExists(title);

    final richTextWidget = tester.element(find.byType(RichText)).widget as RichText;
    var text = richTextWidget.text.toPlainText();

    expect(text, expectedTitle);
  }

  group('TransactionTitle', () {
    testWidgets('does build correctly', (tester) async {
      await tester.runAsync(() async {
        final title = TransactionTitle(TransactionMock.transactionIn);
        await tester.pumpWidget(
          await TestUtils.wrapPrivateRoute(title),
        );

        // Esto espera a que este todo cargado
        await tester.pumpAndSettle();
        TestUtils.widgetExists(title);
      });
    });

    testWidgets('Displays title correctly for in transaction', (tester) async {
      await tester.runAsync(() async {
        await expectTxTitleToBe(
          tester: tester,
          transaction: TransactionMock.transactionIn,
          expectedTitle: 'De test',
        );
      });
    });

    testWidgets('Displays title correctly for out transaction', (tester) async {
      await tester.runAsync(() async {
        await expectTxTitleToBe(
          tester: tester,
          transaction: TransactionMock.transactionOut,
          expectedTitle: 'A test',
        );
      });
    });

    testWidgets('Displays title correctly for recharge transaction', (tester) async {
      await tester.runAsync(() async {
        await expectTxTitleToBe(
          tester: tester,
          transaction: TransactionMock.transactionRecharge,
          expectedTitle: 'Desde Tarjeta bancaria',
        );
      });
    });

    testWidgets('Displays title correctly for culture reward transaction', (tester) async {
      await tester.runAsync(() async {
        await expectTxTitleToBe(
          tester: tester,
          transaction: TransactionMock.cultureRewards,
          expectedTitle: 'De REC Cultural',
        );
      });
    });

    testWidgets('Displays title correctly for ltab reward transaction', (tester) async {
      await tester.runAsync(() async {
        await expectTxTitleToBe(
          tester: tester,
          transaction: TransactionMock.ltabInReward,
          expectedTitle: 'De LTAB',
          state: UserState(
            StorageMock(),
            null,
            user: UserMocks.userLtab(),
          ),
        );
      });
    });
  });
}
