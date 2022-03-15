import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/LimitAndVerification/LimitAndVerification.dart';
import 'package:rec/providers/user_state.dart';

import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('LimitAndVerificationPage test build correctly', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      var app = await TestUtils.wrapPrivateRoute(
        LimitAndVerificationPage(
          pollDocuments: false,
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
