import 'package:flutter_test/flutter_test.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/UserProfile/UserProfile.dart';
import 'package:rec/providers/user_state.dart';

import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  testWidgets('UserProfile test build correctly', (WidgetTester tester) async {
    await tester.runAsync(() async {
      var app = await TestUtils.wrapPrivateRoute(
        UserProfile(),
        userState: UserState(
          RecSecureStorage(),
          null,
          user: UserMocks.userNormal(),
        ),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      TestUtils.widgetExistsByType(UserProfile);
    });
  });

  testWidgets('UserProfile works for users with email', (WidgetTester tester) async {
    await tester.runAsync(() async {
      var app = await TestUtils.wrapPrivateRoute(
        UserProfile(),
        userState: UserState(
          RecSecureStorage(),
          null,
          user: UserMocks.userNormal()..email = 'Test@example.com',
        ),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      TestUtils.widgetExistsByType(UserProfile);
    });
  });
}
