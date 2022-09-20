import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/wallet.page.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/providers/user_state.dart';

import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);
  testWidgets('WalletPage test build correctly', (
    WidgetTester tester,
  ) async {
    var txService = TransactionsService(
      env: env,
      client: MockClient(
        (request) {
          final mapJson = {
            'data': {
              'data': [
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

    var app = await TestUtils.wrapPrivateRoute(
      WalletPageRec(autoReloadEnabled: false),
      userState: UserState(
        RecSecureStorage(),
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

    TestUtils.widgetExistsByType(WalletPageRec);
  });
}
