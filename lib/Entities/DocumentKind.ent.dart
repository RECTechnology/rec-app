import 'package:rec/Entities/Entity.base.dart';

class DocumentKind extends Entity {
  final String name;
  DocumentKind({
    String id,
    String createdAt,
    String updatedAt,
    this.name,
  }) : super(id, createdAt, updatedAt);

  factory DocumentKind.fromJson(Map<String, dynamic> json) {
    return DocumentKind(
      id: json['id'].toString(),
      createdAt: json['created'],
      updatedAt: json['updated'],
      name: json['name'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
