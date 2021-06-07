import 'dart:convert';

import 'package:rec/Entities/Schedule/ScheduleDay.ent.dart';
import 'package:rec/Entities/Schedule/ScheduleType.dart';
import 'package:rec/Helpers/DateHelper.dart';

enum ScheduleState {
  open,
  openAllDay,
  closed,
  notAvailable,
}

class Schedule {
  /// Specifies the type of schedule
  ScheduleType type;

  /// Specifies the schedule for each day of the week
  List<ScheduleDay> days;

  Schedule({
    ScheduleType type,
    List<ScheduleDay> days,
  })  : type = type ?? ScheduleType.NOT_AVAILABLE,
        days = (days != null && days.isNotEmpty)
            ? days
            : List.generate(7, (index) => ScheduleDay());

  /// Returns the state of the schedule for the current day
  /// For example: Closed · Opens at 10am
  ScheduleState getTodayState(DateTime now) {
    if (type == ScheduleType.CLOSED) {
      return ScheduleState.closed;
    }
    if (type == ScheduleType.FULL) {
      return ScheduleState.openAllDay;
    }
    if (type == ScheduleType.TIMETABLE) {
      var isOpen = isOpenToday(now);
      return isOpen ? ScheduleState.open : ScheduleState.closed;
    }

    return ScheduleState.notAvailable;
  }

  String getTodayStateString(DateTime now) {
    var state = getTodayState(now);

    if (state == ScheduleState.notAvailable) return 'NOT_AVAILABLE';
    if (state == ScheduleState.closed) return 'CLOSED';
    if (state == ScheduleState.open) return 'OPEN';
    if (state == ScheduleState.openAllDay) return 'OPEN_ALL_DAY';

    return 'CLOSED';
  }

  /// Returns the schedule for specified [day]
  ScheduleDay getScheduleForDay(int day) {
    return days[day];
  }

  /// Returns the schedule for current day
  ScheduleDay getScheduleForWeekday(DateTime now) {
    return getScheduleForDay(now.weekday - 1);
  }

  /// Returns whether it's opened or closed for current day
  bool isOpenToday(DateTime now) {
    return getScheduleForWeekday(now).isOpen(now);
  }

  DateTime getNextOpeningTime() {
    var today = DateTime.now();
    var todaySchedule = getScheduleForWeekday(today);

    // It's closed so return next opening date
    if (todaySchedule.isClosedForTheDay(today)) {
      for (var day = 1; day <= 7; day++) {
        if (day == today.weekday - 1) continue;

        var nextDay = DateTime(
          today.year,
          today.month,
          today.day,
          today.hour,
          today.minute,
        ).add(Duration(days: day));

        var state = getTodayState(nextDay);
        if (state == ScheduleState.open || state == ScheduleState.openAllDay) {
          return DateHelper.timeStringToDateTime(
            getScheduleForWeekday(nextDay).firstOpen,
            nextDay,
          );
        }
      }
    }

    return todaySchedule.opensAt(today);
  }

  DateTime getNextClosingTime() {
    var today = DateTime.now();
    var todaySchedule = getScheduleForWeekday(today);

    if (todaySchedule.opensThisDate(today)) {
      return todaySchedule.closesAt(today);
    }

    for (var day in days) {
      if (day == todaySchedule) continue;

      var nextDay = today.add(Duration(days: 1));
      if (day.opensThisDate(nextDay)) {
        return DateHelper.timeStringToDateTime(
          getScheduleForWeekday(nextDay).firstClose,
          nextDay,
        );
      }
    }

    return null;
  }

  factory Schedule.fromJsonString(String jsonString) {
    var parsedJson = _tryParseScheduleJsonString(jsonString);
    var days = <ScheduleDay>[];

    if (parsedJson['days'] != null) {
      var jsonWallets = List.from(parsedJson['days']);
      days = jsonWallets.isNotEmpty
          ? jsonWallets
              .map<ScheduleDay>((el) => ScheduleDay.fromJson(el))
              .toList()
          : <ScheduleDay>[];
    }

    return Schedule(
      type: ScheduleType.fromName(parsedJson['type']),
      days: days,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.type,
      'days': days.map((e) => e.toJson()).toList(),
    };
  }

  static Map<String, dynamic> _tryParseScheduleJsonString(String jsonString) {
    try {
      var parsedJson = json.decode(jsonString);
      return parsedJson;
    } catch (e) {
      return {};
    }
  }
}
