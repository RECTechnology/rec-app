import 'package:rec/Base/Entity.base.dart';

import 'Activity.ent.dart';
import 'Product.ent.dart';

class Account extends Entity {
  static String TYPE_PRIVATE = 'PRIVATE';
  static String TYPE_COMPANY = 'COMPANY';

  List<Activity> activities = [];
  List<Product> producingProducts = [];
  List<Product> consumingProducts = [];

  String name;
  String companyImage;
  String publicImage;

  Account({
    String id,
    String createdAt,
    String updatedAt,
    this.name,
    this.activities,
    this.consumingProducts,
    this.producingProducts,
    this.companyImage,
    this.publicImage,
  }) : super(id, createdAt, updatedAt);

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: '${json['id']}',
      createdAt: json['created'],
      updatedAt: json['updated'],
      name: json['name'],
      publicImage: json['public_image'],
      companyImage: json['company_image'],
    );
  }
}
