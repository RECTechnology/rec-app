import 'package:rec/Helpers/Checks.dart';

class DniPhoneData {
  static const String defaultPrefix = '+34';

  String dni;
  String phone;
  String prefix;

  DniPhoneData({
    this.dni,
    this.phone,
    this.prefix = defaultPrefix,
  });

  bool complete() {
    var hasDni = Checks.isNotEmpty(dni);
    var hasPrefix = Checks.isNotEmpty(prefix);
    var hasPhone = Checks.isNotEmpty(phone);

    return hasDni && hasPrefix && hasPhone;
  }
}
