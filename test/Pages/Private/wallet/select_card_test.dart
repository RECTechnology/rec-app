import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:rec/Api/Services/wallet/CardsService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Entities/Forms/RechargeData.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/SelectCard.page.dart';
import 'package:rec/Providers/UserState.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('SelectCard build correctly', (
    WidgetTester tester,
  ) async {
    var cardsService = CardsService(
      client: MockClient(
        (request) {
          final mapJson = {'data': []};
          return Future.value(Response(json.encode(mapJson), 200));
        },
      ),
    );

    var app = TestUtils.wrapPrivateRoute(
      SelectCard(
        cardsService: cardsService,
        rechargeData: RechargeData(),
      ),
      state: UserState(
        RecStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(SelectCard);
  });
}
