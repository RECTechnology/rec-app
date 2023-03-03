import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class BrowserHelper {
  static Future openBrowser(String? url, {LaunchMode? mode}) async {
    if (url == null) return null;

    final uri = Uri.parse(url);
    try {
      return launchUrl(uri, mode: mode ?? LaunchMode.platformDefault);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future openCallPhone(String number) async {
    return await launchUrl(Uri.parse('tel://$number'));
  }

  static Future openEmail(String? email) async {
    return await launchUrl(Uri.parse('mailto://$email'));
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
