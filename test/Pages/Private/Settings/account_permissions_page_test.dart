import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/Permissions/Permissions.page.dart';
import 'package:rec/providers/user_state.dart';

import '../../../mocks/services_mock.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('AccountPermissionsPage test build correctly', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      var app = await TestUtils.wrapPrivateRoute(
        AccountPermissionsPage(
          accountsService: ServicesMock.accountsService,
        ),
        userState: UserState(
          RecSecureStorage(),
          null,
          user: UserMocks.userAdmin(),
        ),
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle(
        const Duration(milliseconds: 500),
      );
    });
  });
}
