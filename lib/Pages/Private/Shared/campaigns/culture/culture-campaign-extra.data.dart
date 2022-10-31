import 'package:rec/config/genders.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class CultureExtraData extends FormData {
  DateTime? birthYear;
  num? zipCode;
  String? gender;

  CultureExtraData({
    this.birthYear,
    this.zipCode,
    this.gender = Genders.initial,
  });

  bool isValid() {
    return (Checks.isNotNull(zipCode) && zipCode! > 0) &&
        Checks.isNotEmpty(gender) &&
        Checks.isNotNull(birthYear);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'dateBirth': DateTime.utc(birthYear!.year, 1, 1).toIso8601String(),
      'zip': zipCode,
      'gender': gender,
    };
  }
}
