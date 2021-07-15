import 'package:rec/Entities/Transactions/Currency.ent.dart';
import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/Transactions/PayInInfo.dart';

class RechargeResult extends Entity {
  static String STATUS_OK = 'ok';
  static String STATUS_KO = 'ko';
  static String STATUS_CANCEL = 'cancel';

  final String status;
  final String message;

  final double amount;

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
      amount: double.parse((json['amount'] ?? 0).toString()),
      message: json['message'],
      currency: Currency.find(json['currency']),
      payInInfo: json['pay_in_info'] != null
          ? PayInInfo.fromJson(json['pay_in_info'])
          : null,
    );
  }
}
