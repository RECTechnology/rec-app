import 'dart:math';

import 'package:rec/Entities/Entity.base.dart';
import 'package:rec/Entities/Transactions/PayInInfo.dart';
import 'package:rec/Entities/Transactions/PayOutInfo.dart';

class TransactionType {
  static String OUT = 'out';
  static String IN = 'in';
  static String RECHARGE = 'recharge';
}

class TransactionMethod {
  static String REC = 'rec';
  static String EUR = 'eur';
}

class Transaction extends Entity {
  String service;
  String method;
  String status;
  String ip;
  String hasDataIn;
  String currency;
  String type;

  TransactionType internalType;

  int amount;
  int total;
  int scale;
  int maxNotificationTries;
  int notificationTries;

  double scaledAmount;
  double variableFee;
  double fixedFee;

  bool internal;
  bool deleted;
  bool notified;

  PayOutInfo payOutInfo;
  PayInInfo payInInfo;

  Transaction({
    String id,
    String createdAt,
    String updatedAt,
    this.service,
    this.method,
    this.status,
    this.ip,
    this.hasDataIn,
    this.currency,
    this.type,
    this.amount,
    this.total,
    this.scale,
    this.variableFee,
    this.fixedFee,
    this.maxNotificationTries,
    this.notificationTries,
    this.internal,
    this.deleted,
    this.notified,
    this.payOutInfo,
    this.payInInfo,
  }) : super(id, createdAt, updatedAt) {
    scaledAmount = (amount / pow(10, scale));
  }

  String getType() {
    return type;
  }

  bool isType(String type) {
    return this.type == type;
  }

  bool isOut() {
    return type == TransactionType.OUT;
  }

  bool isRecharge() {
    return isIn() && hasPayInInfo() && payInInfo.concept == 'Internal exchange';
  }

  bool isIn() {
    return type == TransactionType.IN;
  }

  bool hasPayInInfo() {
    return payInInfo != null;
  }

  bool hasPayOutInfo() {
    return payOutInfo != null;
  }

  String getConcept() {
    if (isRecharge()) {
      return 'RECHARGE_EUR_REC';
    }

    if (isOut()) {
      return payOutInfo.concept;
    }

    if (isIn()) {
      return payInInfo.concept;
    }

    return 'NO_CONCEPT';
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      createdAt: json['created'],
      updatedAt: json['updated'],
      service: json['service'],
      method: json['method'],
      status: json['status'],
      ip: json['ip'],
      hasDataIn: json['has_data_in'],
      currency: json['currency'],
      type: json['type'],
      amount: json['amount'],
      total: json['total'],
      scale: json['scale'],
      variableFee: (json['variable_fee'] ?? 0).toDouble(),
      fixedFee: (json['fixed_fee'] ?? 0).toDouble(),
      maxNotificationTries: json['max_notification_tries'],
      notificationTries: json['notification_tries'],
      internal: json['internal'],
      deleted: json['deleted'],
      notified: json['notified'],
      payOutInfo: json['pay_out_info'] != null
          ? PayOutInfo.fromJson(json['pay_out_info'])
          : null,
      payInInfo: json['pay_in_info'] != null
          ? PayInInfo.fromJson(json['pay_in_info'])
          : null,
    );
  }
}
