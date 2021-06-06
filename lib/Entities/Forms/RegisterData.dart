import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Forms/FormData.dart';
import 'package:rec/Mixins/AccountType.mixin.dart';

class RegisterData extends FormData with AccountType {
  String dni;
  String password;
  String prefix;
  String phone;

  @override
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
      'company_name': companyName,
      'company_cif': companyCif,
    };
  }
}
