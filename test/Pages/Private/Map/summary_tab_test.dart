import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/details_page/widgets/badge_section.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/qualifications/qualification_badge.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
import 'package:rec/Pages/Private/Home/Tabs/map/details_page/summary.tab.dart';

import '../../../mocks/schedule_mock.dart';
import '../../../test_utils.dart';

void main() {
  setUpAll(() => HttpOverrides.global = null);

  testWidgets('Details Page test build correctly', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
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

      var app = await TestUtils.wrapPrivateRoute(SummaryTab(account));

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      TestUtils.widgetExistsByType(SummaryTab);
    });
  });

  testWidgets('Summary page shows badges if account has any badges', (
    WidgetTester tester,
  ) async {
    await tester.runAsync(() async {
      final account = Account(
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
        badges: [
          Badge(
            name: 'test',
            nameEs: 'nameEs',
            nameCa: 'nameCa',
            group: 'group',
            groupEs: 'groupEs',
            groupCa: 'groupCa',
            description: 'description',
            descriptionEs: 'descriptionEs',
            descriptionCa: 'descriptionCa',
            enabled: true,
            imageUrl: 'https://rec.barcelona/wp-content/uploads/2022/05/Nota.svg',
          ),
          Badge(
            name: 'test2',
            nameEs: 'nameEs2',
            nameCa: 'nameCa2',
            group: 'group',
            groupEs: 'groupEs',
            groupCa: 'groupCa',
            description: 'description2',
            descriptionEs: 'descriptionEs2',
            descriptionCa: 'descriptionCa2',
            enabled: true,
            imageUrl: 'https://rec.barcelona/wp-content/uploads/2022/05/Nota.svg',
          )
        ],
      );

      final app = await TestUtils.wrapPrivateRoute(SummaryTab(account));

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      TestUtils.widgetExistsByType(SummaryTab);
      TestUtils.widgetExistsByType(BadgeSection);

      final finder = find.byType(ActionlessQualificationBadge);
      expect(finder, findsNWidgets(2));
    });
  });
}
