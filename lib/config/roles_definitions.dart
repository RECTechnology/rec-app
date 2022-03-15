// coverage:ignore-file


import 'package:rec_api_dart/rec_api_dart.dart';

/// This class holds list of roles for each section/widget/page that requires some roles to see/use it
/// They are later used across the app
class RoleDefinitions {
  static List<Role> admin = [Role.RoleAdmin];
  static List<Role> adminAndWorker = [Role.RoleAdmin, Role.RoleWorker];

  /// Roles for account settings block.
  static List<Role> accountSettings = admin;

  /// Roles for "Manage account" button in account selector modal
  static List<Role> manageAccount = admin;

  /// Roles for recharge
  static List<Role> rechargeRoles = admin;

  /// Roles for pay button in wallet
  static List<Role> payButton = adminAndWorker;

  /// Roles for pay to account button in map
  static List<Role> payButtonMap = adminAndWorker;

  /// Roles for paying from a link
  static List<Role> payFromLink = adminAndWorker;

  /// Roles for pay with QR button in wallet
  static List<Role> payQrButton = adminAndWorker;

  /// Roles for charge button in wallet
  static List<Role> chargeButton = adminAndWorker;
}
