import 'package:rec/Helpers/Checks.dart';
import 'package:rec/Helpers/Strings.dart';

class FormattedAddress {
  String streetType;
  String streetName;
  String streetNumber;
  String city;
  String zip;
  String country;

  FormattedAddress({
    this.streetType,
    this.streetName,
    this.streetNumber,
    this.city,
    this.zip,
    this.country,
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

    return formatted.isEmpty ? '' : Strings.capitalize(formatted);
  }

  factory FormattedAddress.fromJson(Map<String, dynamic> json) {
    return FormattedAddress(
      streetType:
          Checks.isEmpty(json['street_type']) ? 'calle' : json['street_type'],
      streetName: Checks.isEmpty(json['street']) ? null : json['street'],
      streetNumber: Checks.isEmpty(json['address_number'])
          ? null
          : json['address_number'],
      city: json['city'],
      zip: json['zip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street_type': streetType,
      'street': streetName,
      'address_number': streetNumber,
      'zip': zip,
    };
  }
}
