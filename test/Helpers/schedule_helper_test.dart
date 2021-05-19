// ScheduleHelper

import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Helpers/ScheduleHelper.dart';

void main() {
  test('Schedule works without data', () async {
    var nowAtDate = DateTime(2021, 5, 17, 13, 00);
    var schedule = ScheduleHelper.timeStringToDateTime('14:30', nowAtDate);

    expect(schedule.hour, 14);
    expect(schedule.minute, 30);
  });

  test('Schedule works without data', () async {
    var nowAtDate = DateTime(2021, 5, 17, 15, 40);
    var schedule = ScheduleHelper.timeStringToDateTime('16:00', nowAtDate);

    expect(schedule.hour, 16);
    expect(schedule.minute, 00);
  });
}
