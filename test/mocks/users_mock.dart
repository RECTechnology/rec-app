import 'package:rec/Entities/User.ent.dart';

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
}
