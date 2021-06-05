import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/Settings.page.dart';
import 'package:rec/Providers/DocumentsProvider.dart';
import 'package:rec/Providers/UserState.dart';

import '../../../mocks/services_mock.dart';
import '../../../mocks/users_mock.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Settings Page test build correctly', (
    WidgetTester tester,
  ) async {
    var app = TestUtils.wrapPrivateRoute(
      SettingsPage(),
      state: UserState(
        RecStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
      documentsProvider: DocumentsProvider(
        documentsService: ServicesMock.docsService,
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(SettingsPage);
  });
}
