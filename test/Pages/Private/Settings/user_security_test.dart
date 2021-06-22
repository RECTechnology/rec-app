import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/Security/Security.page.dart';
import 'package:rec/Providers/UserState.dart';

import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('UserSecurityPage test build correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(
      UserSecurityPage(),
      state: UserState(
        RecSecureStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(UserSecurityPage);
  });
}