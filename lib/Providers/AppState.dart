import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class AppState with ChangeNotifier {
  final PackageInfo packageInfo;
  AppState({this.packageInfo});

  static AppState of(context) {
    return Provider.of<AppState>(context);
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
}
