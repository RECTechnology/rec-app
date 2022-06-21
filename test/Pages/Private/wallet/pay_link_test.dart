import 'package:flutter_test/flutter_test.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/pay_by_link.page.dart';
import 'package:rec/providers/user_state.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('PayLink build correctly', (
    WidgetTester tester,
  ) async {
    var app = await TestUtils.wrapPrivateRoute(
      PayLink(
        paymentData: PaymentData(
          amount: 1,
          address: 'aaaa',
        ),
      ),
      userState: UserState(
        RecSecureStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(PayLink);
  });
}
