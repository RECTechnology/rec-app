// DateHelper

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

void main() {
  void testForType(
    ScheduleType type,
    ScheduleState expectedState, [
    List<ScheduleDay>? days = const [],
  ]) {
    var schedule = Schedule(
      type: type,
      days: days,
    );

    final state = schedule.getStateForDate(DateTime.now());
    final stateName = schedule.getStateNameForDate(DateTime.now());

    expect(state, expectedState);
    expect(stateName, expectedState.name);
  }

  test('Schedule full returns ScheduleState.openAllDay', () async {
    testForType(ScheduleType.FULL, ScheduleState.openAllDay);
  });

  test('Schedule CLOSED returns ScheduleState.closed', () async {
    testForType(ScheduleType.CLOSED, ScheduleState.closed);
  });

  test('Schedule NOT_AVAILABLE returns ScheduleState.notAvailable', () async {
    testForType(ScheduleType.NOT_AVAILABLE, ScheduleState.notAvailable);
  });

  test('Schedule NOT_AVAILABLE without defined days returns ScheduleState.closed', () async {
    testForType(ScheduleType.TIMETABLE, ScheduleState.closed);
  });

  group('Specific timetable schedules', () {
    test('state is open if currently open', () async {
      final now = DateTime.now();
      final weekday = now.weekday - 1; // remove one as weekday starts at 1
      final days = List.generate(7, (index) => ScheduleDay());
      final formatter = DateFormat.Hm();

      days[weekday] = ScheduleDay(
        firstOpen: formatter.format(now.subtract(Duration(hours: 1))),
        firstClose: formatter.format(now.add(Duration(hours: 7))),
      );

      final schedule = Schedule(
        type: ScheduleType.TIMETABLE,
        days: days,
      );
      expect(schedule.getStateForDate(now), ScheduleState.open);
    });

    test('state is closed if currently closed', () async {
      final now = DateTime.now();
      final weekday = now.weekday - 1; // remove one as weekday starts at 1
      final days = List.generate(7, (index) => ScheduleDay());
      final formatter = DateFormat.Hm();

      days[weekday] = ScheduleDay(
        firstOpen: formatter.format(now.add(Duration(hours: 1))),
        firstClose: formatter.format(now.add(Duration(hours: 7))),
      );

      final schedule = Schedule(
        type: ScheduleType.TIMETABLE,
        days: days,
      );
      expect(schedule.getStateForDate(now), ScheduleState.closed);
    });
  });

  group('Get remaining times until next open/close', () {
    test('returns next opening time', () async {
      final now = DateTime.now();
      final weekday = now.weekday - 1; // remove one as weekday starts at 1
      final days = List.generate(7, (index) => ScheduleDay());
      final formatter = DateFormat.Hm();

      // Create closed schedule for today
      days[weekday] = ScheduleDay(
        firstOpen: formatter.format(now.subtract(Duration(hours: 3))),
        firstClose: formatter.format(now),
      );

      //but open for tomorrow
      days[weekday + 1] = ScheduleDay(
        firstOpen: formatter.format(now.subtract(Duration(hours: 1))),
        firstClose: formatter.format(now.add(Duration(hours: 7))),
      );

      final schedule = Schedule(
        type: ScheduleType.TIMETABLE,
        days: days,
      );
      expect(schedule.getStateForDate(now), ScheduleState.closed);

      final nextOpen = schedule.getNextOpeningTime(now);
      final expectedNextOpen = now.subtract(Duration(hours: 1)).add(Duration(days: 1));

      expect(nextOpen?.day, expectedNextOpen.day);
      expect(nextOpen?.month, expectedNextOpen.month);
      expect(nextOpen?.year, expectedNextOpen.year);
      expect(nextOpen?.hour, expectedNextOpen.hour);
      expect(nextOpen?.minute, expectedNextOpen.minute);
    });
  });
}
