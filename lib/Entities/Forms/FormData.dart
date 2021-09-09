import 'package:rec/Entities/Forms/FieldError.dart';

abstract class FormData {
  Map<String, FieldError> errors = {};

  void addError(String field, String errorMessage) {
    errors[field] = FieldError(fieldName: field, errorMessage: errorMessage);
  }

  void clearError(String field) {
    errors.remove(field);
  }

  bool hasError(String field) {
    return errors[(field ?? '').toLowerCase()] != null;
  }

  String getError(String field) {
    return errors[field]?.errorMessage;
  }

  Map<String, dynamic> toJson();
}
