/// This entity hold the information for an [AccountPermission]
class AccountPermission {
  static final String ROLE_ADMIN = 'ROLE_ADMIN';
  static final String ROLE_WORKER = 'ROLE_WORKER';
  static final String ROLE_READONLY = 'ROLE_READONLY';

  static final List<String> selectableRoles = [
    ROLE_ADMIN,
    ROLE_WORKER,
    ROLE_READONLY,
  ];

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
    roles = rolesList ?? [AccountPermission.ROLE_WORKER];
    phone = data['phone'];
    profileImage = data['profile_image'];
  }
}
