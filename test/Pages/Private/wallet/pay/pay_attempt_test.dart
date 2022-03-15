import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/AttemptPayment.page.dart';
import 'package:rec/providers/user_state.dart';
import '../../../../mocks/users_mock.dart';
import '../../../../test_utils.dart';

void main() {
  testWidgets('AttemptPayment build correctly', (
    WidgetTester tester,
  ) async {
    var txService = TransactionsService(
      env: env,
      client: MockClient(
        (request) {
          final mapJson = {
            'data': {'data': [], 'total': 0}
          };
          return Future.value(Response(json.encode(mapJson), 200));
        },
      ),
    );

    var app = await TestUtils.wrapPrivateRoute(
      AttemptPayment(
        data: PaymentData(amount: 1, address: 'test'),
        transactionsService: txService,
      ),
      userState: UserState(
        RecSecureStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(AttemptPayment);
  });
}
