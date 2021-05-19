import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Entities/Schedule/Schedule.ent.dart';
import 'package:rec/Entities/Schedule/ScheduleType.dart';

var testJson = {
  'type': 'timetable',
  'days': [
    {
      'first_open': '10:00',
      'first_close': '14:00',
      'second_open': '16:00',
      'second_close': '20:00'
    },
    {'first_open': '10:00', 'first_close': '14:00'},
    {},
    {},
    {},
    {},
    {}
  ]
};

void main() {
  test('Schedule works without data', () async {
    var schedule = Schedule();
    expect(schedule.type, ScheduleType.NOT_AVAILABLE);
    expect(schedule.days, const []);
  });

  test('Schedule.fromJsonString works with bad json', () async {
    var schedule = Schedule.fromJsonString('');
    expect(schedule.type, ScheduleType.NOT_AVAILABLE);
    expect(schedule.days, const []);
  });

  test('Schedule.fromJsonString works with good json', () async {
    var schedule = Schedule.fromJsonString(json.encode(testJson));
    expect(schedule.type, ScheduleType.TIMETABLE);

    // Checks that 7 days have been parsed
    expect(
      schedule.days.length,
      7,
    );

    // Checks that the first day matches the one defined in `testJson`
    expect(
      schedule.getScheduleForDay(0).firstOpen,
      '10:00',
    );
  });

  test('Schedule', () async {
    var schedule = Schedule.fromJsonString(json.encode(testJson));

    var date = DateTime(2021, 5, 17, 16, 00);
    var isOpenedNow = schedule.isOpenToday(date);

    expect(isOpenedNow, true);
  });
}
