import 'package:url_launcher/url_launcher.dart';

class BrowserHelper {
  static void openBrowser(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }

  static void openCallPhone(String number) async {
    await launch('tel://$number');
  }
}
