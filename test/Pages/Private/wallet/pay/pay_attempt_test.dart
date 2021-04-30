import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:rec/Api/Services/wallet/TransactionsService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/AttemptPayment.page.dart';
import 'package:rec/Providers/UserState.dart';
import '../../../../mocks/users_mock.dart';
import '../../../../test_utils.dart';

void main() {
  testWidgets('AttemptPayment build correctly', (
    WidgetTester tester,
  ) async {
    var txService = TransactionsService(
      client: MockClient(
        (request) {
          final mapJson = {
            'data': {'data': [], 'total': 0}
          };
          return Future.value(Response(json.encode(mapJson), 200));
        },
      ),
    );

    var app = TestUtils.wrapPrivateRoute(
      AttemptPayment(
        data: PaymentData(),
        transactionsService: txService,
      ),
      state: UserState(
        RecStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(AttemptPayment);
  });
}
