import 'package:rec/Entities/Forms/FormData.dart';
import 'package:rec/Helpers/Checks.dart';

class ChangePinData extends FormData {
  String pin;
  String repin;
  String password;
  String smsCode;

  ChangePinData({
    this.pin,
    this.repin,
    this.password,
    this.smsCode,
  });

  bool get isValid =>
      Checks.isNotEmpty(pin) &&
      Checks.isNotEmpty(repin) &&
      Checks.isNotEmpty(password) &&
      pin == repin;

  @override
  Map<String, dynamic> toJson() {
    return {
      'pin': pin,
      'repin': repin,
      'password': password,
      'sms_code': smsCode,
    };
  }
}
