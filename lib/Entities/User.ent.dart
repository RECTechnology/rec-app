import 'package:rec/Base/Entity.base.dart';
import 'package:rec/Entities/Account.ent.dart';

import 'Wallet.ent.dart';

class User extends Entity {
  List<Wallet> wallets = [];
  List<Account> accounts = [];

  User({
    String id,
    String createdAt,
    String updatedAt,
    this.wallets,
    this.accounts,
  }) : super(id, createdAt, updatedAt);

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
