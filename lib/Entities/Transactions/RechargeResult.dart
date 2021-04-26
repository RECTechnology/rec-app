import 'package:rec/Entities/Currency.ent.dart';
import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/Transactions/PayInInfo.dart';

class RechargeResult extends Entity {
  final String status;
  final String message;

  final int amount;

  final Currency currency;
  final PayInInfo payInInfo;

  RechargeResult({
    String id,
    String createdAt,
    String updatedAt,
    this.status,
    this.message,
    this.amount,
    this.currency,
    this.payInInfo,
  }) : super(id, createdAt, updatedAt);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'amount': amount,
      'message': message,
      'currency': currency,
    };
  }

  factory RechargeResult.fromJson(Map<String, dynamic> json) {
    return RechargeResult(
      id: json['id'],
      createdAt: json['created'],
      updatedAt: json['updated'],
      status: json['status'],
      amount: json['amount'],
      message: json['message'],
      currency: Currency.find(json['currency']),
      payInInfo: json['pay_in_info'] != null
          ? PayInInfo.fromJson(json['pay_in_info'])
          : null,
    );
  }
}
