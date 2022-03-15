// coverage:ignore-file

import 'package:geocoding/geocoding.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

/// Wrapper around `geocoding`
class RecGeocoding {
  static Future<List<Location>> reverseGeocodeAddress(
    FormattedAddress address,
  ) async {
    return locationFromAddress(address.toString());
  }
}
