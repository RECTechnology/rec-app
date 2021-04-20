import 'package:rec/Entities/Entity.base.dart';

class CreditCard extends Entity {
  String alias;
  bool deleted;

  CreditCard({
    String id,
    String createdAt,
    String updatedAt,
    this.alias,
    this.deleted,
  }) : super(id, createdAt, updatedAt);

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      alias: json['alias'],
      deleted: json['deleted'],
    );
  }
}
