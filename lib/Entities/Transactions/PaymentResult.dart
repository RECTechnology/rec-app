import 'package:rec/Entities/Currency.ent.dart';
import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/Transactions/ExtraData.dart';
import 'package:rec/Entities/Transactions/PayOutInfo.dart';

class PaymentResult extends Entity {
  final String status;
  final String message;
  final double amount;
  final int scale;
  final Currency currency;
  final PayOutInfo payOutInfo;
  final ExtraData extraData;

  PaymentResult({
    String id,
    String createdAt,
    String updatedAt,
    this.status,
    this.message,
    this.amount,
    this.scale,
    this.currency,
    this.payOutInfo,
    this.extraData,
  }) : super(id, createdAt, updatedAt);

  bool hasBeenRewarded() {
    return extraData != null && extraData.rewardedLtabAmount != null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'amount': amount,
      'scale': scale,
      'message': message,
      'currency': currency,
    };
  }

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
      id: json['id'],
      createdAt: json['created'],
      updatedAt: json['updated'],
      status: json['status'],
      amount: double.parse((json['amount'] ?? 0).toString()),
      message: json['message'],
      currency: Currency.find(json['currency']),
      payOutInfo: json['pay_out_info'] != null
          ? PayOutInfo.fromJson(json['pay_out_info'])
          : null,
      extraData: json['extra_data'] != null && json['extra_data'] is Map
          ? ExtraData.fromJson(json['extra_data'])
          : null,
    );
  }
}
