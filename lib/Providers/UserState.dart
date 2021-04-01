import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/User.ent.dart';

// UserState is setup in PrivateRoute, each time a private route is rendered
// This is done there because only private routes need access to UserState
// And we can also check if user is logged in
class UserState with ChangeNotifier {
  final RecStorage _storage;

  User _user;
  User _savedUser;
  Account _account;

  UserState(this._storage, this._savedUser);

  static UserState of(context) {
    return Provider.of<UserState>(context);
  }

  static ChangeNotifierProvider<UserState> getProvider(
    RecStorage _storage,
    User savedUser,
  ) {
    return ChangeNotifierProvider(
      create: (context) => UserState(_storage, savedUser),
    );
  }

  void clear() {
    _user = null;
    _account = null;
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

  bool hasSavedUser() {
    return _savedUser != null;
  }

  Future<void> unstoreUser() async {
    _savedUser = null;
    await removeSavedUser(_storage);
    notifyListeners();
  }

  User get savedUser {
    return _savedUser;
  }

  static Future<User> getSavedUser(RecStorage _storage) async {
    var savedUsername = await _storage.read(
      key: RecStorage.PREV_USER_DNI,
    );
    return User(username: savedUsername);
  }

  static Future<void> removeSavedUser(RecStorage _storage) async {
    await _storage.delete(
      key: RecStorage.PREV_USER_DNI,
    );
  }
}
