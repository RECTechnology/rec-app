import 'package:rec/Entities/Entity.base.dart';

class Campaign extends Entity {
  DateTime initDate;
  DateTime endDate;

  int min;
  int max;
  int balance;

  String name;
  String viewPromoUrl;

  Campaign({
    String id,
    String createdAt,
    String updatedAt,
    this.initDate,
    this.endDate,
    this.min,
    this.max,
    this.balance,
    this.name,
    this.viewPromoUrl,
  }) : super(id, createdAt, updatedAt);

  bool isFinished() {
    var currentDate = DateTime.now();
    var diff = endDate.difference(currentDate);
    return diff.inSeconds <= 0;
  }

  bool isStarted() {
    var currentDate = DateTime.now();
    var diff = initDate.difference(currentDate);
    return diff.inSeconds <= 0;
  }

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      initDate: DateTime.parse(json['init_date']),
      endDate: DateTime.parse(json['end_date']),
      min: json['min'],
      max: json['max'],
      balance: json['balance'],
      name: json['name'],
      viewPromoUrl: json['viewPromoUrl'],
    );
  }
}
