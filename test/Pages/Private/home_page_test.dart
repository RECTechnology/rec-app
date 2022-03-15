import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Home/home.page.dart';
import 'package:rec/providers/All.dart';

import '../../mocks/services_mock.dart';
import '../../mocks/users_mock.dart';
import '../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);
  testWidgets('Home Page should build correctly', (
    WidgetTester tester,
  ) async {
    var app = await TestUtils.wrapPrivateRoute(
      HomePage(pollUser: false, defaultTab: 2),
      userState: UserState(
        RecSecureStorage(),
        null,
        user: UserMocks.userNormal(),
      ),
      documentsProvider: DocumentsProvider(
        documentsService: ServicesMock.docsService,
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    TestUtils.widgetExistsByType(HomePage);
    TestUtils.isTextPresent('Mapa');
  });
}
