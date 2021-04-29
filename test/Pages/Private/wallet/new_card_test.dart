import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/AddNewCard.page.dart';
import 'package:rec/Providers/UserState.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('AddNewCard build correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(
      AddNewCard(),
      state: UserState(
        RecStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(AddNewCard);
  });
}