import 'package:flutter_test/flutter_test.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/Security/Security.page.dart';
import 'package:rec/providers/user_state.dart';

import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('UserSecurityPage test build correctly', (
    WidgetTester tester,
  ) async {
    var app = await TestUtils.wrapPrivateRoute(
      UserSecurityPage(),
      userState: UserState(
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
