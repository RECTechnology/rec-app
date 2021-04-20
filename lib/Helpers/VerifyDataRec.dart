class VerifyDataRec {
  static String phoneVerification(String phone) {
    if (phone.length > 9 || phone.length < 9) {
      return 'Incorrect phone';
    } else {
      return null;
    }
  }

  static String verifyPassword(String password) {
    if (password.length >= 6) {
      return null;
    } else {
      return 'incorrect password, min 6 caracter';
    }
  }

  static String verifySMS(String sms) {
    if (sms.length >= 6) {
      return null;
    } else {
      return 'incorrect sms';
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
        return 'Invalid Document';
      }
    }
  }

  static String validateCif(String document) {
    var CIF_REGEX = RegExp(r'^([a-z]|[A-Z]|[0-9])[0-9]{7}([a-z]|[A-Z]|[0-9])');
    if (CIF_REGEX.hasMatch(document)) {
      return null;
    } else {
      return 'Incorrect document';
    }
  }

  static String validateEmail(String email) {
    var EMAIL_REGEX = RegExp(
        r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");
    if (EMAIL_REGEX.hasMatch(email)) {
      return null;
    } else {
      return 'Incorrect email';
    }
  }
}
