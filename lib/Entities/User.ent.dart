import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/Account.ent.dart';

class User extends Entity {
  List<Account> accounts = [];

  Account selectedAccount;
  String username;
  String image;

  bool hasPin = false;

  User({
    String id,
    String createdAt,
    String updatedAt,
    this.username,
    this.accounts,
    this.selectedAccount,
    this.hasPin = false,
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
      hasPin: json['has_pin'],
      selectedAccount: Account.fromJson(json['active_group']),
      accounts: List.from(json['accounts'])
          .map((el) => Account.fromJson(el))
          .toList(),
    );
  }
}
