import 'package:rec/Base/Entity.base.dart';

class Transaction extends Entity {
  Transaction(
    String id,
    String createdAt,
    String updatedAt,
  ) : super(id, createdAt, updatedAt);
}
