import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/map.page.dart';
import 'package:rec/providers/user_state.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Map Page test build correctly', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final app = await TestUtils.wrapPrivateRoute(
        MapPage(),
        userState: UserState(
          RecSecureStorage(),
          null,
          user: UserMocks.userNormal(),
        ),
      );

      await tester.pumpWidget(app);
      // Esto es necesario hacerlo, para que se cargue el Localizations y tengamos acceso a los widgets
      await tester.pumpAndSettle();

      TestUtils.widgetExistsByType(MapPage);
    });
  });
}
