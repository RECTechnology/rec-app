// DateHelper

import 'package:flutter_test/flutter_test.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

void main() {
  test('DateHelper works without data', () async {
    var nowAtDate = DateTime(2021, 5, 17, 13, 00);
    var schedule = DateHelper.timeStringToDateTime('14:30', nowAtDate);

    expect(schedule?.hour, 14);
    expect(schedule?.minute, 30);
  });

  test('DateHelper works without data', () async {
    var nowAtDate = DateTime(2021, 5, 17, 15, 40);
    var schedule = DateHelper.timeStringToDateTime('16:00', nowAtDate);

    expect(schedule?.hour, 16);
    expect(schedule?.minute, 00);
  });
}
