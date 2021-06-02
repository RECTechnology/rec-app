import 'package:rec/Helpers/Checks.dart';

class CreatePermissionData {
  String dni;
  String role;

  CreatePermissionData({
    this.dni,
    this.role,
  });

  bool get isValid => Checks.isNotEmpty(dni) && Checks.isNotEmpty(role);

  CreatePermissionData update(CreatePermissionData newData) {
    dni = newData.dni;
    role = newData.role;
    return this;
  }
}
