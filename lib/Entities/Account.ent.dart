import 'package:rec/Base/Entity.base.dart';

import 'Activity.ent.dart';
import 'Product.ent.dart';

class Account extends Entity {
  List<Activity> activities = [];
  List<Product> producingProducts = [];
  List<Product> consumingProducts = [];

  Account(
    String id,
    String createdAt,
    String updatedAt,
    this.activities,
    this.consumingProducts,
    this.producingProducts,
  ) : super(id, createdAt, updatedAt);

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
