import 'package:rec_api_dart/rec_api_dart.dart';
import 'accounts_mock.dart';

class UserMocks {
  static User userNormal({
    String name = 'test',
  }) =>
      User(
        username: name,
        selectedAccount: AccountsMock.accountNormal,
        accounts: [AccountsMock.accountNormal],
      );

  static User userLtab({
    String name = 'test',
  }) =>
      User(
        username: name,
        selectedAccount: AccountsMock.accountLtab,
        accounts: [AccountsMock.accountLtab],
      );
  static User userAdmin({
    String name = 'admin-test',
  }) =>
      User(
        username: name,
        selectedAccount: AccountsMock.accountNormal,
        accounts: [AccountsMock.accountNormal],
        roles: [Role.RoleAdmin],
      );

  static User userWorker({
    String name = 'worker-test',
  }) =>
      User(
        username: name,
        selectedAccount: AccountsMock.accountNormal,
        accounts: [AccountsMock.accountNormal],
        roles: [Role.RoleWorker],
      );

  static User userReadonly({
    String name = 'readonly-test',
  }) =>
      User(
        username: name,
        selectedAccount: AccountsMock.accountNormal,
        accounts: [AccountsMock.accountNormal],
        roles: [Role.RoleReadonly],
      );
}
