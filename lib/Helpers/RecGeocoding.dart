import 'package:geocoding/geocoding.dart';
import 'package:rec/Entities/FormattedAddress.dart';

class RecGeocoding {
  static Future<List<Location>> reverseGeocodeAddress(
    FormattedAddress address,
  ) async {
    return locationFromAddress(address.toString());
  }
}
