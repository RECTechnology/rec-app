import 'package:rec/Entities/Forms/FormData.dart';
import 'package:rec/Helpers/Checks.dart';

class ChangePasswordData extends FormData {
  String password;
  String repassword;
  String oldPassword;
  String smsCode;

  ChangePasswordData({
    this.password,
    this.repassword,
    this.oldPassword,
    this.smsCode,
  });

  bool get isValid =>
      Checks.isNotEmpty(oldPassword) &&
      Checks.isNotEmpty(password) &&
      Checks.isNotEmpty(repassword) &&
      password == repassword;

  @override
  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'repassword': repassword,
      'old_password': oldPassword,
      'sms_code': smsCode,
    };
  }
}
