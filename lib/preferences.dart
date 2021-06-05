import 'package:google_maps_flutter/google_maps_flutter.dart';

// TODO: refactor this into using PreferenceProvider
class Preferences {
  static Duration userRefreshInterval = Duration(seconds: 60);
  static Duration transactionListRefreshInterval = Duration(seconds: 60);
  static Duration documentsRefreshInterval = Duration(seconds: 30);

  static Duration toastDuration = Duration(seconds: 5);

  static Duration tooltipShowDuration = Duration(seconds: 3);
  static Duration tooltipWaitDuration = Duration(seconds: 0);

  static CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(41.4414534, 2.2086006),
    zoom: 12,
  );
}
