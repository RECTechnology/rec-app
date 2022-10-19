import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

// UserState is setup in PrivateRoute, each time a private route is rendered
// This is done there because only private routes need access to UserState
// And we can also check if user is logged in

/// UserState holds data for the current authenticated user, like it's own data
/// aswell as information about accounts
class UserState with ChangeNotifier {
  static String PREV_USER_DNI = 'previous_user_dni';
  static String PREV_USER_IMAGE = 'previous_user_image';

  final IStorage _storage;
  final UsersService userService;

  UserResume? userResume;
  User? _user;
  User? _savedUser;

  List<DocumentKind> _documentKinds = [];

  UserState(
    this._storage,
    this._savedUser, {
    User? user,
    UsersService? userService,
    UsersService? userResume,
  })  : _user = user,
        userService = userService ?? UsersService(env: env);

  static UserState of(context, {bool listen = true}) {
    return Provider.of<UserState>(context, listen: listen);
  }

  static UserState deaf(context) {
    return Provider.of<UserState>(context, listen: false);
  }

  static ChangeNotifierProvider<UserState> getProvider(
    IStorage _storage,
    User savedUser,
  ) {
    return ChangeNotifierProvider(
      create: (context) => UserState(_storage, savedUser),
    );
  }

  Future<User> getUser() {
    return userService.getUser().then((user) {
      setUser(user);
      setSelectedAccount(user.selectedAccount);
      return user;
    });
  }

  Future<UserResume> getUserResume() {
    return userService.getUserResume().then((resume) {
      setUserResume(resume);
      return resume;
    }).catchError((e) {
      print(e);
    });
  }

  void clear() {
    _user = null;
  }

  User? get user {
    return _user;
  }

  void setSavedUser(User user) {
    _storage.write(key: UserState.PREV_USER_DNI, value: user.username);
    _savedUser = user;
    notifyListeners();
  }

  void setUser(User user) {
    _user = user;
    setSavedUser(user);
  }

  void setUserResume(UserResume resume) {
    userResume = resume;
    notifyListeners();
  }

  void setDocumentKinds(List<DocumentKind> kinds) {
    _documentKinds = kinds;
    notifyListeners();
  }

  void setSelectedAccount(Account? account) {
    _user?.selectedAccount = account;
    notifyListeners();
  }

  Account? get account {
    return user?.selectedAccount;
  }

  String? get username {
    return _user != null ? user!.username : '...';
  }

  List<DocumentKind> get documentKinds {
    return _documentKinds;
  }

  bool hasSavedUser() {
    return _savedUser != null && _savedUser!.username != null;
  }

  Future<void> unstoreUser() async {
    _savedUser = null;
    await removeSavedUser(_storage);
    notifyListeners();
  }

  User? get savedUser {
    return _savedUser;
  }

  static Future<User> getSavedUser(IStorage _storage) async {
    var savedUsername = await _storage.read(
      key: UserState.PREV_USER_DNI,
    );
    return User(username: savedUsername);
  }

  static Future<void> removeSavedUser(IStorage _storage) async {
    await _storage.delete(
      key: UserState.PREV_USER_DNI,
    );
  }
}
