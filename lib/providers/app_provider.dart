import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:rec/environments/env.dart';
import 'package:rec_api_dart/rec_api_dart.dart';
// import 'package:rec/extensions/config_settings_app_extension.dart';

class AppProvider with ChangeNotifier {
  final AppService _appService;
  final PackageInfo packageInfo;

  ConfigurationSettings? configurationSettings;

  AppProvider({required this.packageInfo, AppService? appService})
      : _appService = appService ?? AppService(env: env) {
    print('${packageInfo.packageName} @ ${packageInfo.version}');
  }

  Future<void> loadConfigurationSettings() async {
    configurationSettings = await _appService.getConfigurationSettings();
    debugPrint('Loaded configurationSettings ${configurationSettings?.settingsMap}');
    notifyListeners();
  }

  String get buildNumber {
    return packageInfo.buildNumber;
  }

  String get packageName {
    return packageInfo.packageName;
  }

  String get version {
    return packageInfo.version;
  }

  int get versionInt {
    try {
      var versionClean = version.split('-');
      var versionInt = versionClean[0].replaceAll('.', '');
      return int.parse(versionInt);
    } catch (error) {
      return 61;
    }
  }

  static ChangeNotifierProvider<AppProvider> getProvider(
    PackageInfo packageInfo,
    AppService appService,
  ) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(
        packageInfo: packageInfo,
        appService: appService,
      ),
    );
  }

  static AppProvider of(context, {bool listen = false}) {
    return Provider.of<AppProvider>(context, listen: listen);
  }
}
