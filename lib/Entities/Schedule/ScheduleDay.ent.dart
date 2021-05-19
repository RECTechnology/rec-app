import 'package:rec/Helpers/ScheduleHelper.dart';

class ScheduleDay {
  final String firstOpen;
  final String firstClose;
  final String secondOpen;
  final String secondClose;

  ScheduleDay({
    this.firstOpen,
    this.firstClose,
    this.secondOpen,
    this.secondClose,
  });

  bool isOpen(DateTime date) {
    var firstOpened = _isFirstOpened(date);
    var secondOpened = _isSecondOpened(date);

    return firstOpened || secondOpened;
  }

  bool isClosed(DateTime date) => !isOpen(date);

  bool isClosedForTheDay(DateTime now) {
    if (firstClose == null ||
        firstClose.isEmpty && secondClose == null ||
        secondClose.isEmpty) return true;

    var secondclose = ScheduleHelper.timeStringToDateTime(secondClose, now);
    return now.isAfter(secondclose);
  }

  bool isDefined() {
    return isFirstDefined() || isSecondDefined();
  }

  bool isFirstDefined() => firstClose != null && firstClose.isNotEmpty;
  bool isSecondDefined() => secondClose != null && secondClose.isNotEmpty;

  DateTime closesAt(DateTime now) {
    var firstclose = ScheduleHelper.timeStringToDateTime(firstClose, now);
    var secondclose = ScheduleHelper.timeStringToDateTime(secondClose, now);

    if (_isFirstOpened(now)) {
      return firstclose;
    }

    return secondclose;
  }

  DateTime opensAt(DateTime now) {
    var firstopen = ScheduleHelper.timeStringToDateTime(firstOpen, now);
    var secondopen = ScheduleHelper.timeStringToDateTime(secondOpen, now);

    if (!_isFirstOpened(now)) {
      return secondopen;
    }

    return firstopen;
  }

  bool opensThisDate(DateTime now) {
    if (firstOpen == null || firstOpen.isEmpty) return false;
    if (secondOpen == null || secondOpen.isEmpty) return false;

    var firstopen = ScheduleHelper.timeStringToDateTime(firstOpen, now);
    var secondclose = ScheduleHelper.timeStringToDateTime(secondClose, now);

    return (now.isAfter(firstopen) || now.isAtSameMomentAs(firstopen)) &&
        now.isBefore(secondclose);
  }

  bool _isFirstOpened(DateTime now) {
    if (firstOpen == null || firstOpen.isEmpty) {
      return false;
    }

    var firstopen = ScheduleHelper.timeStringToDateTime(firstOpen, now);
    var firstclose = ScheduleHelper.timeStringToDateTime(firstClose, now);

    return (now.isAfter(firstopen) || now.isAtSameMomentAs(firstopen)) &&
        now.isBefore(firstclose);
  }

  bool _isSecondOpened(DateTime now) {
    if (secondOpen == null || secondOpen.isEmpty) {
      return false;
    }

    var secondopen = ScheduleHelper.timeStringToDateTime(secondOpen, now);
    var secondclose = ScheduleHelper.timeStringToDateTime(secondClose, now);

    return (now.isAfter(secondopen) || now.isAtSameMomentAs(secondopen)) &&
        now.isBefore(secondclose);
  }

  factory ScheduleDay.fromJson(Map<String, dynamic> json) {
    return ScheduleDay(
      firstOpen: json['first_open'] ?? '',
      firstClose: json['first_close'] ?? '',
      secondOpen: json['second_open'] ?? '',
      secondClose: json['second_close'] ?? '',
    );
  }
}
