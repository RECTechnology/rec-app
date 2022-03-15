import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/day_sales.page.dart';
import 'package:rec/providers/transactions_provider.dart';
import 'package:rec/providers/user_state.dart';

import '../../../mocks/services_mock.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('AccountDaySalesPage test build correctly', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      var app = await TestUtils.wrapPrivateRoute(
        AccountDaySalesPage(),
        userState: UserState(
          RecSecureStorage(),
          null,
          user: UserMocks.userNormal(),
        ),
        providers: [
          ChangeNotifierProvider(
            create: (context) => TransactionProvider(
              ServicesMock.createTxService({
                'data': {
                  'in': 4 * pow(10, 8),
                  'out': -1 * pow(10, 8),
                  'total': 3 * pow(10, 8),
                }
              }),
            ),
          ),
        ],
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      TestUtils.isTextPresent('+4,00');
      TestUtils.isTextPresent('-1,00');
      TestUtils.isTextPresent('+3,00');
    });
  });
}
