import 'package:flutter/foundation.dart';
import 'package:rec/Entities/Forms/FormData.dart';
import 'package:rec/Helpers/Checks.dart';

class CreateDocumentData extends FormData {
  String content;
  String name;
  String kind_id;

  CreateDocumentData({
    @required this.content,
    @required this.name,
    @required this.kind_id,
  });

  bool get isValid => Checks.isNotEmpty(content) && Checks.isNotEmpty(kind_id);

  @override
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'name': name,
      'kind_id': kind_id,
    };
  }
}
