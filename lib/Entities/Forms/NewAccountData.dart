import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/Forms/FormData.dart';
import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Mixins/AccountType.mixin.dart';

class NewAccountData extends FormData with AccountType {
  @override
  String accountType;
  String name;
  String cif;

  NewAccountData({
    this.accountType = Account.TYPE_PRIVATE,
    this.name = '',
    this.cif = '',
  });

  bool get isValid {
    if (isAccountPrivate && Checks.isNotEmpty(name)) return true;

    return Checks.isNotEmpty(name) && Checks.isNotEmpty(cif);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'account_name': name,
      'company_cif': cif,
      'company_prefix': '',
      'company_phone': '',
      'type': accountType,
    };
  }
}
