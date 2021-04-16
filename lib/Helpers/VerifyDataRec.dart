class VerifyDataRec {
  static String phoneVerification(String phone) {
    if (phone.length > 9 || phone.length < 9) {
      return 'ERROR_PHONE';
    } else {
      return null;
    }
  }

  static String verifyPassword(String password) {
    if (password.length >= 6) {
      return null;
    } else {
      return 'ERROR_PASS_MIN_6';
    }
  }

  static String verifySMS(String sms) {
    if (sms.length >= 6) {
      return null;
    } else {
      return 'ERROR_SMS';
    }
  }

  static String verifyIdentityDocument(String document) {
    var DNI_REGEX = RegExp(r'^(\d{8})([A-Z])$', caseSensitive: false);
    var NIE_REGEX = RegExp(r'^[XYZ]\d{7,8}[A-Z]$');
    if (DNI_REGEX.hasMatch(document)) {
      return null;
    } else {
      if (NIE_REGEX.hasMatch(document)) {
        return null;
      } else {
        return 'ERROR_DNI';
      }
    }
  }

  static String validateCif(String document) {
    var CIF_REGEX = RegExp(r'^([a-z]|[A-Z]|[0-9])[0-9]{7}([a-z]|[A-Z]|[0-9])');
    if (CIF_REGEX.hasMatch(document)) {
      return null;
    } else {
      return 'ERROR_CIF';
    }
  }
}
