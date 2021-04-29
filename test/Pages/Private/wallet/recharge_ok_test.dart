import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/RechargeOK.page.dart';
import 'package:rec/Providers/UserState.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('RechargeOK build correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(
      RechargeOK(amount: 100),
      state: UserState(
        RecStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(RechargeOK);
  });
}