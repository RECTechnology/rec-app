import 'package:flutter/widgets.dart';
import 'package:rec/Entities/Currency.ent.dart';
import 'package:rec/Entities/Forms/FormData.dart';
import 'package:rec/Entities/VendorData.ent.dart';

class PaymentData extends FormData {
  double amount;
  String concept;
  String address;
  String pin;
  VendorData vendor;
  Currency currency;

  PaymentData({
    @required this.amount,
    @required this.address,
    this.concept = '',
    this.pin,
    VendorData vendor,
    Currency currency,
  })  : currency = currency ?? Currency.rec,
        vendor = vendor ?? VendorData();

  PaymentData.empty() {
    amount = null;
    address = '';
    concept = '';
    vendor = VendorData();
    currency = Currency.rec;
  }

  PaymentData.fromUriString(String uri) {
    var parsedUri = Uri.parse(uri);
    currency = Currency.rec;
    amount = double.parse(parsedUri.queryParameters['amount']);
    concept = parsedUri.queryParameters['concept'];
    address = parsedUri.queryParameters['address'];
  }

  int get scaledAmount {
    return (amount * 100000000).toInt();
  }

  double descaleAmount(double amount) {
    return (amount / 100000000).toDouble();
  }

  bool isComplete() {
    return amount > 0 &&
        concept != null &&
        concept.isNotEmpty &&
        vendor != null;
  }

  PaymentData update(PaymentData newData) {
    currency = newData.currency;
    vendor = newData.vendor;
    amount = newData.amount;
    address = newData.address;
    concept = newData.concept;
    pin = newData.pin;

    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'amount': scaledAmount,
      'concept': concept,
      'address': address,
      'pin': pin,
    };
  }

  Map<String, dynamic> toDeeplinkJson() {
    // ignore: omit_local_variable_types
    Map<String, dynamic> map = {};

    if (amount != null) {
      map['amount'] = '$amount';
    }
    if (concept != null && concept.isNotEmpty) {
      map['concept'] = concept;
    }
    if (address != null && address.isNotEmpty) {
      map['address'] = address;
    }

    return map;
  }
}
