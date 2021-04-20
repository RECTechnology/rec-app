import 'package:rec/Entities/Entity.base.dart';

class Activity extends Entity {
  Activity({
    String id,
    String createdAt,
    String updatedAt,
  }) : super(id, createdAt, updatedAt);

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
