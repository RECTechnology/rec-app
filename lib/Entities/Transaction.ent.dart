import 'package:rec/Base/Entity.base.dart';

class Transaction extends Entity {
  Transaction({
    String id,
    String createdAt,
    String updatedAt,
  }) : super(id, createdAt, updatedAt);

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      createdAt: json['created'],
      updatedAt: json['updated'],
    );
  }
}
