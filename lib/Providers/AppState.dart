import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class AppState with ChangeNotifier {
  final PackageInfo packageInfo;
  AppState({this.packageInfo}) {
    print('${packageInfo.packageName} @ ${packageInfo.version}');
  }

  static AppState of(context, {bool listen = false}) {
    return Provider.of<AppState>(context, listen: listen);
  }

  static ChangeNotifierProvider<AppState> getProvider(PackageInfo packageInfo) {
    return ChangeNotifierProvider(
      create: (context) => AppState(packageInfo: packageInfo),
    );
  }

  String get version {
    return packageInfo.version;
  }

  String get buildNumber {
    return packageInfo.buildNumber;
  }

  String get packageName {
    return packageInfo.packageName;
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
}
