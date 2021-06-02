/// This entity hold the information for an [AccountPermission]
class AccountPermission {
  static final String ROLE_USER = 'ROLE_USER';
  static final String ROLE_ADMIN = 'ROLE_ADMIN';
  static final String ROLE_MANAGER = 'ROLE_MANAGER';
  static final String ROLE_WORKER = 'ROLE_WORKER';
  static final String ROLE_READONLY = 'ROLE_READONLY';
  static final String ROLE_COMPANY = 'ROLE_COMPANY';

  /// List of all available roles
  /// WARNING: Order is important in this list, as it indicates the role hierarchy
  static final List<String> allRoles = [
    ROLE_ADMIN,
    ROLE_MANAGER,
    ROLE_WORKER,
    ROLE_USER,
    ROLE_READONLY,
    ROLE_COMPANY,
  ];

  static final List<String> selectableRoles = [
    ROLE_ADMIN,
    ROLE_MANAGER,
    ROLE_WORKER,
    ROLE_USER,
    ROLE_READONLY,
  ];

  /// WARNING: It mutates the list
  static void sortRolesByHierarchy(List<String> statuses) {
    statuses.sort((a, b) {
      return allRoles.indexOf(a) - allRoles.indexOf(b);
    });
  }

  int id;
  String username;
  String email;
  List<String> roles;
  String phone;
  String profileImage;

  AccountPermission.fromJson(dynamic data) {
    var jsonRoles = data['roles'];
    var rolesList = <String>[];

    if (jsonRoles is List) rolesList = List<String>.from(jsonRoles);
    if (jsonRoles is Map) {
      rolesList = Map<dynamic, String>.from(jsonRoles).values.toList();
    }

    id = data['id'];
    username = data['username'];
    email = data['email'];
    roles = rolesList ?? [AccountPermission.ROLE_USER];
    phone = data['phone'];
    profileImage = data['profile_image'];

    sortRolesByHierarchy(roles);
    //
  }
}
