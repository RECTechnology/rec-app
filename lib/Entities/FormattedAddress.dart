import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Helpers/Strings.dart';

class FormattedAddress {
  final String streetType;
  final String streetName;
  final String streetNumber;
  final String city;
  final String zip;
  final String country;

  FormattedAddress({
    this.streetType = '',
    this.streetName = '',
    this.streetNumber = '',
    this.city = '',
    this.zip = '',
    this.country = '',
  });

  @override
  String toString() {
    var streetWithNumber = [
      streetType,
      streetName,
      streetNumber,
    ].where(Checks.isNotEmpty).join(' ');

    var cityWithZip = [city, zip].where(Checks.isNotEmpty).join(' ');
    var formatted = [streetWithNumber, cityWithZip, country]
        .where(Checks.isNotEmpty)
        .join(', ');

    return formatted.isEmpty ? 'NOT_SPECIFIED' : Strings.capitalize(formatted);
  }

  factory FormattedAddress.fromJson(Map<String, dynamic> json) {
    return FormattedAddress(
      streetType: json['street_type'],
      streetName: json['street'],
      streetNumber: json['street_number'],
      city: json['city'],
      zip: json['zip'],
    );
  }
}
