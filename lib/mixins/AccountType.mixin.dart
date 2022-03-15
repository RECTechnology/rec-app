import 'package:rec_api_dart/rec_api_dart.dart';

mixin AccountType {
  String? accountType;

  void setAccountType(type) => accountType = type;

  bool get isAccountPrivate => accountType == Account.TYPE_PRIVATE;
  bool get isAccountCompany => accountType == Account.TYPE_COMPANY;

  void setToCompany() {
    setAccountType(Account.TYPE_COMPANY);
  }

  void setToPrivate() {
    setAccountType(Account.TYPE_PRIVATE);
  }
}
