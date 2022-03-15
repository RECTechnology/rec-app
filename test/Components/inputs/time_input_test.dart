import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Components/Inputs/TimeInput.dart';

import '../../test_utils.dart';

void main() {
  testWidgets('TimeInput initiates', (WidgetTester tester) async {
    String? onChangedResult;
    var timeOfDay = TimeOfDay(
      hour: 10,
      minute: 0,
    );

    var widget = TimeInput(
      closed: false,
      value: '10:00',
      onChange: (String value) {
        onChangedResult = value;
      },
      getTime: (c) {
        return Future.value(timeOfDay);
      },
    );
    await tester.pumpWidget(
      TestUtils.wrapPublicRoute(
        widget,
      ),
    );
    await tester.pumpAndSettle();
    TestUtils.widgetExists(widget);

    await tester.tap(find.byWidget(widget));
    await tester.pumpAndSettle();

    expect(onChangedResult, '10:00');
  });
}
