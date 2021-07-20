import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Helpers/DateHelper.dart';

// TODO: Clean this class, improve naming, etc...
class ScheduleDay {
  static final ScheduleDay defaultSchedule = ScheduleDay(
    firstOpen: '9:00',
    firstClose: '14:00',
    secondOpen: '17:00',
    secondClose: '20:00',
  );

  String firstOpen;
  String firstClose;
  String secondOpen;
  String secondClose;
  bool opens;

  ScheduleDay({
    this.firstOpen,
    this.firstClose,
    this.secondOpen,
    this.secondClose,
    this.opens = true,
  });

  /// Sets times to predefined one [ScheduleDay.defaultSchedule]
  void resetToDefaultTime() {
    copyFrom(defaultSchedule);
  }

  /// Copies the data from another [ScheduleDay] into this
  void copyFrom(ScheduleDay otherDay) {
    firstOpen = otherDay.firstOpen;
    firstClose = otherDay.firstClose;
    secondOpen = otherDay.secondOpen;
    secondClose = otherDay.secondClose;
    opens = otherDay.opens;
  }

  bool isOpen(DateTime date) {
    var firstOpened = _isFirstOpened(date);
    var secondOpened = _isSecondOpened(date);

    return opens && (firstOpened || secondOpened);
  }

  bool isClosed(DateTime date) => !isOpen(date);

  bool isClosedForTheDay(DateTime now) {
    if (Checks.isEmpty(firstOpen) && Checks.isEmpty(secondOpen)) return true;

    var hasFirstClose = Checks.isNotEmpty(firstClose);
    var hasSecondClose = Checks.isNotEmpty(secondClose);

    if (hasFirstClose && !hasSecondClose) {
      var firstclose = DateHelper.timeStringToDateTime(firstClose, now);
      return now.isAfter(firstclose);
    } else if (hasSecondClose) {
      var secondclose = DateHelper.timeStringToDateTime(secondClose, now);
      return now.isAfter(secondclose);
    }

    return true;
  }

  bool isDefined() {
    return isFirstDefined() || isSecondDefined();
  }

  bool isFirstDefined() => Checks.isNotEmpty(firstClose);
  bool isSecondDefined() => Checks.isNotEmpty(secondClose);

  DateTime closesAt(DateTime now) {
    var firstclose = DateHelper.timeStringToDateTime(firstClose, now);
    var secondclose = DateHelper.timeStringToDateTime(secondClose, now);

    if (_isFirstOpened(now)) {
      return firstclose;
    }

    return secondclose;
  }

  DateTime opensAt(DateTime now) {
    var firstopen = DateHelper.timeStringToDateTime(firstOpen, now);
    var secondopen = DateHelper.timeStringToDateTime(secondOpen, now);

    if (!_isFirstOpened(now)) {
      return secondopen;
    }

    return firstopen;
  }

  bool opensThisDate(DateTime now) {
    if (firstOpen == null || firstOpen.isEmpty) return false;
    if (secondOpen == null || secondOpen.isEmpty) return false;

    var firstopen = DateHelper.timeStringToDateTime(firstOpen, now);
    var secondclose = DateHelper.timeStringToDateTime(secondClose, now);

    return (now.isAfter(firstopen) || now.isAtSameMomentAs(firstopen)) &&
        now.isBefore(secondclose);
  }

  bool _isFirstOpened(DateTime now) {
    if (firstOpen == null || firstOpen.isEmpty) {
      return false;
    }

    var firstopen = DateHelper.timeStringToDateTime(firstOpen, now);
    var firstclose = DateHelper.timeStringToDateTime(firstClose, now);

    return (now.isAfter(firstopen) || now.isAtSameMomentAs(firstopen)) &&
        now.isBefore(firstclose);
  }

  bool _isSecondOpened(DateTime now) {
    if (secondOpen == null || secondOpen.isEmpty) {
      return false;
    }

    var secondopen = DateHelper.timeStringToDateTime(secondOpen, now);
    var secondclose = DateHelper.timeStringToDateTime(secondClose, now);

    return (now.isAfter(secondopen) || now.isAtSameMomentAs(secondopen)) &&
        now.isBefore(secondclose);
  }

  Map<String, dynamic> toJson() {
    return {
      'first_open': firstOpen,
      'first_close': firstClose,
      'second_open': secondOpen,
      'second_close': secondClose,
      'opens': opens,
    };
  }

  factory ScheduleDay.fromJson(Map<String, dynamic> json) {
    var firstOpen = json['first_open'];
    var firstClose = json['first_close'];
    var secondOpen = json['second_open'];
    var secondClose = json['second_close'];

    /// For old schedule data
    if (!json.containsKey('opens')) {
      var hasFirst =
          Checks.isNotEmpty(firstOpen) && Checks.isNotEmpty(firstClose);
      var hasSecond =
          Checks.isNotEmpty(secondOpen) && Checks.isNotEmpty(secondClose);

      json['opens'] = hasFirst || hasSecond;
    }

    return ScheduleDay(
      firstOpen: firstOpen,
      firstClose: firstClose,
      secondOpen: secondOpen,
      secondClose: secondClose,
      opens: json['opens'] ?? false,
    );
  }
}
