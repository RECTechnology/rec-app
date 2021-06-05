import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/Recharge.page.dart';
import 'package:rec/Providers/UserState.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('RechargePage build correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(
      RechargePage(),
      state: UserState(
        RecStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(RechargePage);
  });
}
