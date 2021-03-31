import 'package:rec/Base/Entity.base.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'Wallet.ent.dart';

class User extends Entity {
  List<Wallet> wallets = [];
  List<Account> accounts = [];

  Account selectedAccount;
  String username;

  User({
    String id,
    String createdAt,
    String updatedAt,
    this.username,
    this.wallets,
    this.accounts,
    this.selectedAccount,
  }) : super(id, createdAt, updatedAt);

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      username: json['username'],
      selectedAccount: Account.fromJson(json['active_group']),
      accounts: List.from(json['accounts'])
          .map((el) => Account.fromJson(el))
          .toList(),
    );
  }
}
