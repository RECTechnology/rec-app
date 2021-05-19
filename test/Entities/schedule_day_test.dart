import 'package:flutter_test/flutter_test.dart';
import 'package:rec/Entities/Schedule/ScheduleDay.ent.dart';

void main() {
  test('ScheduleDay.isOpen with opened works', () async {
    var today = ScheduleDay(
      firstOpen: '10:00',
      firstClose: '14:00',
      secondOpen: '16:00',
      secondClose: '20:00',
    );

    var now = DateTime.now();
    var nowAtDate = DateTime(now.year, now.month, now.day, 13, 00);
    expect(today.isOpen(nowAtDate), true);
  });

  test('ScheduleDay.isOpen with closed schedule works', () async {
    var today = ScheduleDay(
      firstOpen: '10:00',
      firstClose: '14:00',
      secondOpen: '16:00',
      secondClose: '20:00',
    );

    var nowInPast = DateTime(1990, 2, 10, 22, 20);
    expect(today.isOpen(nowInPast), false);
  });

  test('ScheduleDay.isOpen with only first opened works', () async {
    var today = ScheduleDay(
      firstOpen: '10:00',
      firstClose: '14:00',
    );

    var date = DateTime(2021, 5, 17, 13, 00);
    expect(today.isOpen(date), true);
  });

  test('ScheduleDay.isOpen with only second opened works', () async {
    var today = ScheduleDay(
      secondOpen: '10:00',
      secondClose: '14:00',
    );

    var date = DateTime(2021, 5, 17, 13, 00);
    expect(today.isOpen(date), true);
  });

  test('ScheduleDay.isOpen weird case', () async {
    var today = ScheduleDay(
      firstOpen: '9:00',
      firstClose: '12:00',
      secondOpen: '16:00',
      secondClose: '22:00',
    );

    var date = DateTime(2021, 5, 17, 13, 00);
    expect(today.isOpen(date), false);
  });

  test('ScheduleDay.closesAt with opened works', () async {
    var today = ScheduleDay(
      firstOpen: '9:00',
      firstClose: '14:00',
      secondOpen: '16:00',
      secondClose: '20:00',
    );

    var nowAtDate = DateTime(2021, 5, 17, 13, 00);
    var closeDate = today.closesAt(nowAtDate);
    expect(closeDate.hour, 14);
    expect(closeDate.minute, 0);
  });

  test('ScheduleDay.closesAt with opened works for second', () async {
    var today = ScheduleDay(
      firstOpen: '9:00',
      firstClose: '12:00',
      secondOpen: '13:00',
      secondClose: '20:00',
    );

    var nowAtDate = DateTime(2021, 5, 17, 13, 00);
    var closeDate = today.closesAt(nowAtDate);
    expect(closeDate.hour, 20);
    expect(closeDate.minute, 0);
  });

  test('ScheduleDay.opensAt with closed works', () async {
    var today = ScheduleDay(
      firstOpen: '9:00',
      firstClose: '12:00',
      secondOpen: '16:00',
      secondClose: '22:00',
    );

    var nowAtDate = DateTime(2021, 5, 17, 14, 00);
    var closeDate = today.opensAt(nowAtDate);
    expect(closeDate.hour, 16);
    expect(closeDate.minute, 0);
  });
}
