import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Forms/FormData.dart';

class RegisterData extends FormData {
  String dni;
  String password;
  String prefix;
  String phone;

  String accountType;
  bool termsAccepted = false;

  // Only if type COMPANY
  String companyName;
  String companyCif;

  RegisterData({
    this.dni,
    this.password,
    this.prefix,
    this.phone,
    this.accountType,
    this.companyName,
    this.companyCif,
  });

  bool get isAccountPrivate => accountType == Account.TYPE_PRIVATE;
  bool get isAccountCompany => accountType == Account.TYPE_COMPANY;

  @override
  Map<String, dynamic> toJson() {
    if (accountType == Account.TYPE_PRIVATE) {
      return {
        'dni': dni,
        'password': password,
        'prefix': prefix,
        'phone': phone,
      };
    }

    return {
      'dni': dni,
      'password': password,
      'prefix': prefix,
      'phone': phone,
      'name': companyName,
      'cif': companyCif,
    };
  }
}
