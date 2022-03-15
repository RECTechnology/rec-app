import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecPlatform {
  static Future closeApp(BuildContext context) {
    return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
