import 'package:rec/Helpers/Checks.dart';

class UnlockUserData {
  String dni;
  String phone;
  String prefix;
  String sms;

  UnlockUserData({this.dni, this.phone, this.prefix,this.sms});

  bool complete() {
    var hasDni = Checks.isNotEmpty(dni);
    var hasPrefix = Checks.isNotEmpty(prefix);
    var hasPhone = Checks.isNotEmpty(phone);
    var hasSMS = Checks.isNotEmpty(sms);

    return hasDni && hasPrefix && hasPhone && hasSMS;
  }
}
