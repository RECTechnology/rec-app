import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class BrowserHelper {
  static Future openBrowser(url) async {
    if (await canLaunchUrl(url)) {
      return await launchUrl(url);
    }
  }

  static Future openCallPhone(String number) async {
    return await launchUrl(Uri.parse('tel://$number'));
  }

  static Future openMarketOrPlayStore(appPackageName) async {
    if (Platform.isAndroid) {
      return await openBrowser(
        'https://play.google.com/store/apps/details?id=' + appPackageName,
      );
    }
    if (Platform.isIOS) {
      return await openBrowser('market://details?id=' + appPackageName);
    }
  }
}
