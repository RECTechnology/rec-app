import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Helpers/DateHelper.dart';

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
    if (Checks.isEmpty(firstOpen) && Checks.isEmpty(secondOpen)) return true;

    var hasFirstClose = Checks.isNotEmpty(firstClose);
    var hasSecondClose = Checks.isNotEmpty(secondClose);

    if (hasFirstClose && hasSecondClose) return true;

    var secondclose = DateHelper.timeStringToDateTime(secondClose, now);
    return now.isAfter(secondclose);
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

  factory ScheduleDay.fromJson(Map<String, dynamic> json) {
    return ScheduleDay(
      firstOpen: json['first_open'] ?? '',
      firstClose: json['first_close'] ?? '',
      secondOpen: json['second_open'] ?? '',
      secondClose: json['second_close'] ?? '',
    );
  }
}
