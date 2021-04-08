import 'package:rec/Base/Entity.base.dart';
import 'dart:math';

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
  ClientData clientData;

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
    this.clientData,
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

class PayOutInfo {
  String address;
  String txId;
  String status;
  String imageReceiver;
  String nameReceiver;
  String concept;

  int amount;

  bool isFinal;

  PayOutInfo({
    this.address,
    this.amount,
    this.txId,
    this.status,
    this.isFinal,
    this.imageReceiver,
    this.nameReceiver,
    this.concept,
  });

  factory PayOutInfo.fromJson(Map<String, dynamic> json) {
    return PayOutInfo(
      address: json['address'],
      amount: json['amount'],
      concept: json['concept'] ?? '',
      txId: json['txid'],
      status: json['status'],
      isFinal: json['final'],
      imageReceiver: json['image_receiver'],
      nameReceiver: json['name_receiver'],
    );
  }
}

class PayInInfo {
  int amount;
  int received;
  int scale;
  int expiresIn;
  int minComfirmations;
  int confimations;

  String currency;
  String address;
  String txId;
  String status;
  String concept;
  String imageSender;
  String nameSender;

  bool isFinal;

  PayInInfo({
    this.amount,
    this.received,
    this.scale,
    this.expiresIn,
    this.minComfirmations,
    this.confimations,
    this.currency,
    this.address,
    this.txId,
    this.status,
    this.concept,
    this.isFinal,
    this.imageSender,
    this.nameSender,
  });

  factory PayInInfo.fromJson(Map<String, dynamic> json) {
    return PayInInfo(
      amount: json['amount'],
      received: json['received'],
      scale: json['scale'],
      expiresIn: json['expires_in'],
      minComfirmations: json['min_comfirmations'],
      confimations: json['confimations'],
      currency: json['currency'],
      concept: json['concept'],
      address: json['address'],
      txId: json['txid'],
      status: json['status'],
      isFinal: json['final'],
      imageSender: json['image_sender'],
      nameSender: json['name_sender'],
    );
  }
}

class ClientData {
  ClientData() {}

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData();
  }
}
