class ScheduleHelper {
  static String getWeekdayName(int weekday) {
    if (weekday == 1) return 'MONDAY';
    if (weekday == 2) return 'TUESDAY';
    if (weekday == 3) return 'WEDNESDAY';
    if (weekday == 4) return 'THURSDAY';
    if (weekday == 5) return 'FRIDAY';
    if (weekday == 6) return 'SATURDAY';
    if (weekday == 7) return 'SUNDAY';
    return null;
  }

  static DateTime timeStringToDateTime(String time, DateTime now) {
    if (time == null || time.isEmpty) {
      return now.add(Duration(days: 1000));
    }

    var hourMinuteParts = time.split(':');
    var hours = int.parse(hourMinuteParts[0]);
    var minutes = int.parse(hourMinuteParts[1]);

    return DateTime(
      now.year,
      now.month,
      now.day,
      hours,
      minutes,
    );
  }
}
