import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Wallet/transaction_icon.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

import '../../mocks/transactions_mock.dart';
import '../../mocks/users_mock.dart';
import '../../test_utils.dart';

testBuildsForTx(WidgetTester tester, Transaction tx, {User? user}) async {
  await dotenv.load(fileName: "env/test.env");

  var txIcon = TransactionIcon(tx);

  await tester.pumpWidget(
    await TestUtils.wrapPrivateRoute(
      Container(
        child: txIcon,
      ),
      userState: UserState(
        RecSecureStorage(),
        null,
        user: user ?? UserMocks.userNormal(),
      ),
    ),
  );

  // Esto espera a que este todo cargado
  await tester.pumpAndSettle();

  TestUtils.widgetExists(txIcon);
}

void main() {
  group('TransactionIcon', () {
    testWidgets('should build with transactionIn', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await testBuildsForTx(tester, TransactionMock.transactionIn);
      });
    });

    testWidgets('should build with transactionOut', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await testBuildsForTx(tester, TransactionMock.transactionOut);
      });
    });

    testWidgets('should build with transactionRecharge', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await testBuildsForTx(tester, TransactionMock.transactionRecharge);
      });
    });

    testWidgets('should build with transactionIn from Ltab Account', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await testBuildsForTx(
          tester,
          TransactionMock.transactionIn,
          user: UserMocks.userLtab(),
        );
      });
    });
  });
}
