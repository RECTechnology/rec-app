import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/Account.ent.dart';

class User extends Entity {
  List<Account> accounts = [];

  Account selectedAccount;
  String username;
  String image;

  User({
    String id,
    String createdAt,
    String updatedAt,
    this.username,
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
            .toList());
  }
}
