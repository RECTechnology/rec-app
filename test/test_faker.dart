import 'package:faker/faker.dart';

class TestFaker {
  static final faker = Faker();

  static DateTime date({int minYear = 2020, int maxYear = 2022}) {
    return TestFaker.faker.date.dateTime(
      minYear: minYear,
      maxYear: maxYear,
    );
  }

  static String isoDate({int minYear = 2020, int maxYear = 2022}) {
    return TestFaker.faker.date
        .dateTime(
          minYear: minYear,
          maxYear: maxYear,
        )
        .toIso8601String();
  }
}
