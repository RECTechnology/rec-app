import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Services/TransactionsService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Components/Wallet/TransactionListTile.dart';
import 'package:rec/Entities/Transaction.ent.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/transactions/TransactionsList.tab.dart';
import 'package:rec/Providers/TransactionsProvider.dart';
import 'package:rec/Providers/UserState.dart';

import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('TransactionList builds correctly', (
    WidgetTester tester,
  ) async {
    var txService = TransactionsService(
      client: MockClient(
        (request) {
          final mapJson = {
            'data': {
              'elements': [
                {
                  'type': 'in',
                  'amount': 1000,
                  'total': 1000,
                  'scale': 8,
                  'method': TransactionMethod.REC,
                  'pay_in_info': {
                    'concept': 'test',
                    'name_sender': 'test',
                  },
                }
              ],
              'total': 0
            }
          };
          return Future.value(Response(json.encode(mapJson), 200));
        },
      ),
    );

    var app = TestUtils.wrapPrivateRoute(
      TransactionsList(),
      state: UserState(
        RecStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
      providers: [
        ChangeNotifierProvider(
          create: (context) => TransactionProvider(txService),
        ),
      ],
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(TransactionsList);
    TestUtils.widgetExistsByType(TransactionsListTile);
  });
}