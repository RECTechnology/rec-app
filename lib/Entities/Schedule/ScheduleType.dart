class ScheduleType {
  final String type;

  @override
  String toString() => type;

  ScheduleType(this.type);

  /// [FULL] means the schedule is opened 24 h
  static ScheduleType FULL = ScheduleType('full');

  /// [TIMETABLE] means the schedule has set a schedule for each weekday
  static ScheduleType TIMETABLE = ScheduleType('timetable');

  /// [CLOSED] means the schedule is closed
  static ScheduleType CLOSED = ScheduleType('closed');

  /// [NOT_AVAILABLE] means the schedule is not available
  static ScheduleType NOT_AVAILABLE = ScheduleType('not_available');

  static List<ScheduleType> values = [
    FULL,
    TIMETABLE,
    CLOSED,
    NOT_AVAILABLE,
  ];

  static Map<String, ScheduleType> map = {
    FULL.type: FULL,
    TIMETABLE.type: TIMETABLE,
    CLOSED.type: CLOSED,
    NOT_AVAILABLE.type: NOT_AVAILABLE,
  };

  static ScheduleType fromName(String name) => ScheduleType.map[name];
}
