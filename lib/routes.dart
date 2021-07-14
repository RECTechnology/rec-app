import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/All.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/All.dart';

import 'package:rec/Pages/Public/Register/RegisterStepOne.dart';
import 'package:rec/Pages/Public/UnlockUser/UnlockUserPage.dart';
import 'package:rec/Pages/Public/Login/Login.page.dart';

import 'package:rec/Pages/Private/Home/Home.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/BussinessAccount.page.dart';

import 'package:rec/Environments/env.dart';
import 'package:rec/Components/PrivateRoute.dart';

/// List of all Route names and some utilities for handling routes
class Routes {
  // Public routes
  static String login = 'login';
  static String register = 'register';
  static String forgotPassword = 'forgot-password';
  static String changePassword = 'change-password';
  static String unlockUser = 'unlock-user';

  // Walet routes
  static String payQr = 'pay-qr';
  static String payContactAccount = 'pay-contact-account';
  static String recharge = 'recharge';
  static String charge = 'charge';

  // Route for deeplink recharge result
  static String rechargeResult = 'recharge-result';
  static String rechargeResultRedirect = '/recharge-result';
  static String payLink = '/pay';
  static String unlockUserLink = '/unlock-user';

  static String home = 'home';
  static String newCard = 'new-card';

  // Settings routes
  static String settingsUserProfile = 'settings-user-profile';
  static String settingsUserLimits = 'settings-user-limits';
  static String settingsUserSecurity = 'settings-user-security';
  static String settingsUserPassword = 'settings-user-change-password';
  static String settingsUserChangePin = 'settings-user-change-pin';
  static String settingsUserCreatePin = 'settings-user-create-pin';

  static String settingsUserDocuments = 'settings-user-documents';
  static String settingsUserGeneral = 'settings-user-general';
  static String settingsUserMainAccount = 'settings-user-main-account';
  static String settingsUserGeneralLanguage = 'settings-user-general-language';

  static String settingsYourAccount = 'settings-your-account';
  static String settingsBussinessAccount = 'settings-bussiness-account-map';
  static String settingsAccountPermissions = 'settings-account-permissions';
  static String settingsAccountLocation = 'settings-account-location';
  static String settingsAccountContact = 'settings-account-contact';
  static String settingsAccountSchedule = 'settings-account-schedule';
  static String settingsAddNewAccount = 'settings-add-new-account';

  static String getInitialRoute({bool hasToken = true}) {
    return hasToken ? Routes.home : Routes.login;
  }

  /// The route generator callback used when the app is navigated to a named route.
  /// If this returns null when building the routes to handle the specified [initialRoute],
  /// then all the routes are discarded and [Navigator.defaultRouteName] is used instead (/). See [initialRoute].
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (settings.name.startsWith(Routes.payLink)) {
      return PayLink.handleRoute(settings, env);
    }

    if (settings.name.startsWith(Routes.unlockUserLink)) {
      return UnlockUserPage.handleRoute(settings, env);
    }

    return null;
  }
}

/// List of all NAMED Routes
final Map<String, Widget Function(BuildContext)> ROUTES = {
  // Public routes
  Routes.login: (context) => LoginPage(),
  Routes.register: (context) => RegisterOne(),
  Routes.unlockUser: (context) => UnlockUserPage(),

  // Main private routes
  Routes.home: (context) => PrivateRoute(HomePage()),
  Routes.recharge: (context) => RechargePage(),
  Routes.payQr: (context) => PayWithQR(),
  Routes.payContactAccount: (context) => PayContactOrAccount(),
  Routes.charge: (context) => ChargePage(),

  // User settings
  Routes.settingsUserSecurity: (context) => UserSecurityPage(),
  Routes.settingsUserProfile: (context) => UserProfile(),
  Routes.settingsUserMainAccount: (context) => MainAccountPage(),
  Routes.settingsUserGeneral: (context) => GeneralSettingsPage(),
  Routes.settingsUserGeneralLanguage: (context) => ChangeLanguagePage(),
  Routes.settingsUserPassword: (context) => ChangePasswordPage(),
  Routes.settingsUserChangePin: (context) => ChangePinPage(),
  Routes.settingsUserCreatePin: (context) => CreatePinPage(),
  Routes.settingsUserDocuments: (context) => LimitAndVerificationPage(),

  // Account settings
  Routes.settingsAccountPermissions: (context) => AccountPermissionsPage(),
  Routes.settingsYourAccount: (context) => MyAccountPage(),
  Routes.settingsBussinessAccount: (context) => BussinessAccountPage(),
  Routes.settingsAddNewAccount: (context) => AddNewAccountPage(),
  Routes.settingsAccountLocation: (context) => AccountLocationPage(),
  Routes.settingsAccountContact: (context) => AccountContactPage(),
  Routes.settingsAccountSchedule: (context) => AccountSchedulePage(),
};
