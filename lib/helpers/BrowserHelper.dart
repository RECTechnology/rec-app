import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class BrowserHelper {
  static Future openBrowser(String? url, {LaunchMode? mode}) async {
    if (url == null) return null;

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: mode ?? LaunchMode.platformDefault);
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

  @Deprecated('')
  static Future openGoogleMaps([double? latitude = 0, double? longitude = 0]) {
    if (Platform.isAndroid) {
      final geoURL = 'geo://$latitude,$longitude';
      return openBrowser(geoURL);
    }
    if (Platform.isIOS) {
      final iosUrl = 'http://maps.apple.com/?ll=$latitude,$longitude';
      return openBrowser(iosUrl);
    }

    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    return openBrowser(url, mode: LaunchMode.externalApplication);
  }
}
