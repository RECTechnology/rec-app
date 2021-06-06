import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/Api/Services/UsersService.dart';
import 'package:rec/Api/Storage.dart';
import 'package:rec/Entities/Account.ent.dart';
import 'package:rec/Entities/DocumentKind.ent.dart';
import 'package:rec/Entities/User.ent.dart';
import 'package:rec/brand.dart';

// UserState is setup in PrivateRoute, each time a private route is rendered
// This is done there because only private routes need access to UserState
// And we can also check if user is logged in

/// UserState holds data for the current authenticated user, like it's own data
/// aswell as information about accounts
class UserState with ChangeNotifier {
  final RecSecureStorage _storage;
  final UsersService _userService;

  User _user;
  User _savedUser;

  List<DocumentKind> _documentKinds = [];

  UserState(
    this._storage,
    this._savedUser, {
    User user,
    UsersService userService,
  })  : _user = user,
        _userService = userService ?? UsersService();

  static UserState of(context, {bool listen = true}) {
    return Provider.of<UserState>(context, listen: listen);
  }

  static ChangeNotifierProvider<UserState> getProvider(
    RecSecureStorage _storage,
    User savedUser,
  ) {
    return ChangeNotifierProvider(
      create: (context) => UserState(_storage, savedUser),
    );
  }

  Future<User> getUser() {
    return _userService.getUser().then((user) {
      setUser(user);
      return user;
    });
  }

  void clear() {
    _user = null;
  }

  User get user {
    return _user;
  }

  void setSavedUser(User user) {
    _storage.write(key: RecSecureStorage.PREV_USER_DNI, value: user.username);
    _savedUser = user;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    setSavedUser(user);
  }

  void setDocumentKinds(List<DocumentKind> kinds) {
    _documentKinds = kinds;
    notifyListeners();
  }

  void setSelectedAccount(Account account) {
    _user?.selectedAccount = account;
    notifyListeners();
  }

  Account get account {
    return user?.selectedAccount;
  }

  String get username {
    return _user != null ? user.username : '...';
  }

  List<DocumentKind> get documentKinds {
    return _documentKinds;
  }

  bool hasSavedUser() {
    return _savedUser != null && _savedUser.username != null;
  }

  Future<void> unstoreUser() async {
    _savedUser = null;
    await removeSavedUser(_storage);
    notifyListeners();
  }

  User get savedUser {
    return _savedUser;
  }

  /// Returns the color for the current account
  Color getColor({Color defaultColor = Brand.grayDark}) {
    return account == null ? defaultColor : Brand.getColorForAccount(account);
  }

  static Future<User> getSavedUser(RecSecureStorage _storage) async {
    var savedUsername = await _storage.read(
      key: RecSecureStorage.PREV_USER_DNI,
    );
    return User(username: savedUsername);
  }

  static Future<void> removeSavedUser(RecSecureStorage _storage) async {
    await _storage.delete(
      key: RecSecureStorage.PREV_USER_DNI,
    );
  }
}
