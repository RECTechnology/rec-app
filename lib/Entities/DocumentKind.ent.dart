import 'package:rec/Entities/Entity.base.dart';

class DocumentKind extends Entity {
  final String name;
  final String description;
  final bool isUserDocument;

  DocumentKind({
    String id,
    String createdAt,
    String updatedAt,
    bool isUserDocument,
    this.name = '',
    this.description = '',
  })  : isUserDocument = isUserDocument ?? false,
        super(id, createdAt, updatedAt);

  factory DocumentKind.fromJson(Map<String, dynamic> json) {
    return DocumentKind(
      id: json['id'].toString(),
      createdAt: json['created'],
      updatedAt: json['updated'],
      name: json['name'],
      description: json['description'],
      isUserDocument: json['is_user_document'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
