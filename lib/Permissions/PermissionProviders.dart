import 'package:rec/Permissions/providers/CameraPermissionProvider.dart';
import 'package:rec/Permissions/providers/ContactsPermissionProvider.dart';
import 'package:rec/Permissions/PermissionProvider.dart';
import 'package:rec/Permissions/providers/LocationPermissionProvider.dart';
import 'package:rec/Permissions/providers/QrPermissionProvider.dart';

class PermissionProviders {
  static PermissionProvider qr = QrPermissionProvider();
  static PermissionProvider camera = CameraPermissionProvider();
  static PermissionProvider contacts = ContactsPermissionProvider();
  static PermissionProvider location = LocationPermissionProvider();
}
