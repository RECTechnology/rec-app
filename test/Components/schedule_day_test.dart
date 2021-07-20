import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/ListTiles/ScheduleDayInput.dart';
import 'package:rec/Entities/Schedule/ScheduleDay.ent.dart';

import '../test_utils.dart';

void main() {
  testWidgets('ScheduleDayInput initiates', (WidgetTester tester) async {
    var widget = ScheduleDayInput(
      day: ScheduleDay.defaultSchedule,
      weekday: 1,
      closed: false,
      opens24Hours: false,
      onChange: (ScheduleDay value) {},
      onAction: (CopyPasteAction value) {},
    );

    await tester.pumpWidget(
      TestUtils.wrapPublicRoute(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [widget],
              ),
            )
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    TestUtils.widgetExists(widget);
  });
}
