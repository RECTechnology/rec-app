class Validators {
  static String? payMinimum(String? str) {
    if (str == null) return 'ERROR_PASS_MIN_6';

    var amount = double.parse(str);
    if (amount >= 1) {
      return null;
    }

    return 'ERROR_PASS_MIN_6';
  }

  static String? isRequired(String? str) {
    if (str == null || str.isEmpty) return 'IS_REQUIRED';

    return null;
  }

  static String? isEmail(String? string) {
    // Null or empty string is invalid
    if (string == null || string.isEmpty) {
      return 'INVALID_EMAIL';
    }

    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,16}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return 'INVALID_EMAIL';
    }
    return null;
  }

  static String? verifyPassword(String? password) {
    if (password != null && password.length >= 6) {
      return null;
    } else {
      return 'ERROR_PASS_MIN_6';
    }
  }

  static String? Function(String? str) exactLength(
    int length, {
    String message = 'ERROR_LENGTH',
  }) {
    return (String? str) {
      var hasError = str == null || str.isEmpty || str.length < length;
      return hasError ? message : null;
    };
  }

  static String? pin(String? str) {
    if (str == null) return 'PIN_MIN_LENGTH';

    if (str.length > 4) {
      return 'PIN_MAX_LENGTH';
    }

    if (str.isEmpty) {
      return 'PIN_MIN_LENGTH';
    }

    return null;
  }

  static String? smsCode(String? str) {
    if (str == null) return 'PIN_MIN_LENGTH';
    if (str.length > 6) return 'SMS_MAX_LENGTH';
    if (str.isEmpty) return 'SMS_MIN_LENGTH';

    return null;
  }

  static String? verifyIdentityDocument(String? str) {
    var DNI_REGEX = RegExp(r'^(\d{8})([A-Z])$', caseSensitive: false);
    var NIE_REGEX = RegExp(r'^[XYZ]\d{7,8}[A-Z]$');

    if (str == null) return 'PIN_MIN_LENGTH';

    if (DNI_REGEX.hasMatch(str.trim())) return null;
    if (NIE_REGEX.hasMatch(str.trim())) return null;

    return 'ERROR_DNI';
  }

  static String? validateCif(String? document) {
    var CIF_REGEX = RegExp(r'^([a-z]|[A-Z]|[0-9])[0-9]{7}([a-z]|[A-Z]|[0-9])');

    if (document != null && CIF_REGEX.hasMatch(document.trim())) {
      return null;
    }
    return 'ERROR_CIF';
  }
}
