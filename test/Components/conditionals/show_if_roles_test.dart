import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/conditionals/show_if_roles.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import '../../mocks/users_mock.dart';
import '../../test_utils.dart';

void main() {
  testWidgets('ShowIfRoles works without roles', (WidgetTester tester) async {
    await tester.runAsync(() async {
      var textKey = GlobalKey();

      var testWidget = ShowIfRoles(
        validRoles: [],
        child: Text('Bla', key: textKey),
      );

      var widgetWithProviders = await TestUtils.wrapPrivateRoute(
        testWidget,
        userState: UserState(
          RecSecureStorage(),
          null,
          user: UserMocks.userNormal(),
        ),
      );

      await tester.pumpWidget(widgetWithProviders);
      await tester.pumpAndSettle();

      TestUtils.widgetExistsByKey(textKey);
    });
  });

  testWidgets('ShowIfRoles works with user with correct roles', (WidgetTester tester) async {
    await tester.runAsync(() async {
      var textKey = GlobalKey();

      var testWidget = ShowIfRoles(
        validRoles: [Role.RoleWorker],
        child: Text('Bla', key: textKey),
      );

      var widgetWithProviders = await TestUtils.wrapPrivateRoute(
        testWidget,
        userState: UserState(
          RecSecureStorage(),
          null,
          user: UserMocks.userWorker(),
        ),
      );

      await tester.pumpWidget(widgetWithProviders);
      await tester.pumpAndSettle();

      TestUtils.widgetExistsByKey(textKey);
    });
  });

  testWidgets('ShowIfRoles works with user without correct roles', (WidgetTester tester) async {
    await tester.runAsync(() async {
      var textKey = GlobalKey();

      var testWidget = ShowIfRoles(
        validRoles: [Role.RoleWorker],
        child: Text('Bla', key: textKey),
      );

      var widgetWithProviders = await TestUtils.wrapPrivateRoute(
        testWidget,
        userState: UserState(
          RecSecureStorage(),
          null,
          user: UserMocks.userReadonly(),
        ),
      );

      await tester.pumpWidget(widgetWithProviders);
      await tester.pumpAndSettle();

      TestUtils.widgetExistsByKey(textKey, matcher: findsNothing);
    });
  });
}
