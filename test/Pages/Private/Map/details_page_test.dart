import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Schedule/Schedule.ent.dart';
import 'package:rec/Pages/Private/Home/Tabs/Map/DetailsPage/Details.page.dart';

import '../../../mocks/schedule_mock.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Details  Page test build correctly', (
    WidgetTester tester,
  ) async {
    var account = Account(
      addressString: 'Avenida',
      webUrl: 'https://www.google.com/search?',
      phone: '691087803',
      type: 'open',
      name: 'Hellou',
      latitude: 40.56890,
      longitude: 40.56890,
      description: 'helou',
      scheduleString: ScheduleMock.mockJson1,
      schedule: Schedule.fromJsonString(ScheduleMock.mockJson1),
    );

    var app = TestUtils.wrapPrivateRoute(DetailsPage(account));

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    TestUtils.widgetExistsByType(DetailsPage);
  });
}
