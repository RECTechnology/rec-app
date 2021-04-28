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
    this.amount = 0,
    this.concept = 'pago',
    this.address = '',
    this.pin,
    this.vendor,
    Currency currency,
  }) : currency = currency ?? Currency.rec;

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
    return {
      'amount': '$amount',
      'concept': concept,
      'address': address,
    };
  }
}
