import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rec/Entities/Forms/PaymentData.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/AddNewAccount.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/AccountContact.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/AccountLocation.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/AccountSchedule.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/MyAccount.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/LimitAndVerification/LimitAndVerification.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/account/Permissions/Permissions.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/Security/ChangePassword.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/Security/ChangePin.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/Security/CreatePin.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/Security/Security.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/UserProfile/UserProfile.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/charge/Charge.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/PayContactOrAccount.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/PayLink.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/pay/PayWithQR.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Wallet/recharge/Recharge.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/General.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/GeneralSettings/PrincipalAccount.page.dart';
import 'package:rec/Pages/Private/Home/Tabs/Settings/user/GeneralSettings/Language.page.dart';
import 'package:rec/Pages/Public/Register/RegisterStepOne.dart';
import 'package:rec/Pages/Public/UnlockUser/UnlockUserPage.dart';

import 'Pages/Private/Home/Home.page.dart';
import 'Pages/Private/Home/Tabs/Settings/account/BussinessAccount.page.dart';
import 'Pages/Public/Login/Login.page.dart';
import 'Components/PrivateRoute.dart';

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

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {

    if (settings.name.startsWith(Routes.payLink)) {
      return MaterialPageRoute(
        builder: (ctx) => PayLink(
          paymentData: PaymentData.fromUriString(
            'https://rec.barcelona' + settings.name,
          ),
        ),
      );
    }
    if (settings.name.startsWith(Routes.unlockUserLink)) {
      var uri = 'https://rec.barcelona' + settings.name;
      var params = Uri.parse(uri).queryParameters;
      var sms = params['smscode'];
      return MaterialPageRoute(
        builder: (ctx) => UnlockUserPage(sms: sms,),
      );
    }
    return null;
  }
}

final Map<String, Widget Function(BuildContext)> ROUTES = {
  Routes.login: (context) => LoginPage(),
  Routes.register: (context) => RegisterOne(),
  Routes.home: (context) => PrivateRoute(HomePage()),
  Routes.recharge: (context) => RechargePage(),
  Routes.payQr: (context) => PayWithQR(),
  Routes.payContactAccount: (context) => PayContactOrAccount(),
  Routes.charge: (context) => ChargePage(),
  Routes.unlockUser: (context) => UnlockUserPage(),

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
