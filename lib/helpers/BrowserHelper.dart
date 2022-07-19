import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class BrowserHelper {
  static Future openBrowser(String? url) async {
    if (url == null) return null;

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
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

  static Future openGoogleMaps([double? latitude = 0, double? longitude = 0]) {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    return openBrowser(url);
  }
}
