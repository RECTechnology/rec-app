// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/day_sales.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/all.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/offers/AccountOffers.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/help.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/All.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/select-recharge-type.dart';

import 'package:rec/Pages/Public/Register/RegisterStepOne.dart';
import 'package:rec/Pages/Public/UnlockUser/UnlockUserPage.dart';
import 'package:rec/Pages/Public/Login/Login.page.dart';

import 'package:rec/Pages/Private/Home/home.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/BussinessAccount.page.dart';

import 'package:rec/Pages/Public/init_page.dart';
import 'package:rec/environments/env.dart';

/// List of all Route names and some utilities for handling routes
class Routes {
  // Public routes
  static const String init = 'init';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String changePassword = 'change-password';
  static const String unlockUser = 'unlock-user';

  // Walet routes
  static const String payQr = 'pay-qr';
  static const String payContactAccount = 'pay-contact-account';
  static const String selectRecharge = 'select-recharge';
  static const String recharge = 'recharge';
  static const String charge = 'charge';

  // Route for deeplink recharge result
  static const String rechargeResult = 'recharge-result';
  static const String rechargeResultRedirect = '/recharge-result';
  static const String payLink = '/pay';
  static const String unlockUserLink = '/unlock-user';

  static const String home = 'home';
  static const String newCard = 'new-card';

  // Settings routes
  static const String settingsUserProfile = 'settings-user-profile';
  static const String settingsUserLimits = 'settings-user-limits';
  static const String settingsUserSecurity = 'settings-user-security';
  static const String settingsUserPassword = 'settings-user-change-password';
  static const String settingsUserChangePin = 'settings-user-change-pin';
  static const String settingsUserCreatePin = 'settings-user-create-pin';

  static const String settingsUserDocuments = 'settings-user-documents';
  static const String settingsUserGeneral = 'settings-user-general';
  static const String settingsUserMainAccount = 'settings-user-main-account';
  static const String settingsUserGeneralLanguage =
      'settings-user-general-language';

  static const String settingsYourAccount = 'settings-your-account';
  static const String settingsBussinessAccount =
      'settings-bussiness-account-map';
  static const String settingsAccountPermissions =
      'settings-account-permissions';
  static const String settingsAccountLocation = 'settings-account-location';
  static const String settingsAccountContact = 'settings-account-contact';
  static const String settingsAccountSchedule = 'settings-account-schedule';
  static const String settingsAccountOffers = 'settings-account-offers';
  static const String settingsAddNewAccount = 'settings-add-new-account';
  static const String settingsDaySales = 'settings-day-sales';

  static const String settingsHelp = 'settings-help';

  static String getInitialRoute({bool hasToken = true}) {
    return hasToken ? Routes.home : Routes.login;
  }

  /// The route generator callback used when the app is navigated to a named route.
  /// If this returns null when building the routes to handle the specified [initialRoute],
  /// then all the routes are discarded and [Navigator.defaultRouteName] is used instead (/). See [initialRoute].
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name!.startsWith(Routes.payLink)) {
      return PayLink.handleRoute(settings, env);
    }

    if (settings.name!.startsWith(Routes.unlockUserLink)) {
      return UnlockUserPage.handleRoute(settings, env);
    }

    return null;
  }
}

/// List of all NAMED Routes
final Map<String, Widget Function(BuildContext)> ROUTES = {
  // Public routes
  Routes.init: (context) => InitPage(),
  Routes.login: (context) => LoginPage(),
  Routes.register: (context) => RegisterOne(),
  Routes.unlockUser: (context) => UnlockUserPage(),

  // Main private routes
  Routes.home: (context) => HomePage(),
  Routes.selectRecharge: (context) => SelectRechargePage(),
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
  Routes.settingsAccountOffers: (context) => AccountOffersPage(),
  Routes.settingsDaySales: (context) => AccountDaySalesPage(),

  // Other settings
  Routes.settingsHelp: (context) => HelpPage(),
};
