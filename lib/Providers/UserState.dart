import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/User.ent.dart';

// UserState is setup in PrivateRoute, each time a private route is rendered
// This is done there because only private routes need access to UserState
// And we can also check if user is logged in
class UserState with ChangeNotifier {
  final RecStorage _storage = RecStorage();

  User _user;
  Account _account;

  static UserState of(context) {
    return Provider.of<UserState>(context);
  }

  static ChangeNotifierProvider<UserState> getProvider() {
    return ChangeNotifierProvider(create: (context) => UserState());
  }

  void clear() {
    _user = null;
    _account = null;
    _storage.delete(key: RecStorage.PREV_USER_DNI);
  }

  User get user {
    return _user;
  }

  void setUser(User user) {
    _user = user;
    _storage.write(key: RecStorage.PREV_USER_DNI, value: user.username);
    notifyListeners();
  }

  Account get account {
    return _account;
  }

  void setAccount(Account account) {
    _account = account;
    notifyListeners();
  }

  String get username {
    return _user != null ? user.username : '...';
  }

  Future<bool> hasSavedUser() async {
    var savedUsername = await _storage.read(
      key: RecStorage.PREV_USER_DNI,
    );
    return savedUsername != null;
  }

  Future<User> getSavedUser() async {
    var savedUsername = await _storage.read(
      key: RecStorage.PREV_USER_DNI,
    );
    return User(username: savedUsername);
  }

  Future<void> removeSavedUser() async {
    await _storage.delete(
      key: RecStorage.PREV_USER_DNI,
    );
    notifyListeners();
  }
}
