import 'package:rec/Entities/Entity.base.dart';

class Product extends Entity {
  Product({
    String id,
    String createdAt,
    String updatedAt,
  }) : super(id, createdAt, updatedAt);

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
