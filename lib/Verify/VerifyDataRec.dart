class VerifyDataRec {
  static bool passwordVerifycation(String password) {
    if (password.length >= 6) {
      return true;
    } else {
      return false;
    }
  }

  static bool phoneVerification(String prefix, String phone) {
    if (prefix == "+34") {
      if (phone.length == 9) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static bool verifyIdentityDocument(String document) {
    var DNI_REGEX = new RegExp(r"^(\d{8})([A-Z])$", caseSensitive: false);
    var NIE_REGEX = new RegExp(r"^[XYZ]\d{7,8}[A-Z]$");
    if (DNI_REGEX.hasMatch(document)) {
      return true;
    } else {
      if (NIE_REGEX.hasMatch(document)) {
        return true;
      } else {
        return false;
      }
    }
  }

  static bool validateCif(String document){
    var CIF_REGEX = new RegExp(r"^([ABCDEFGHJKLMNPQRSUVW])(\d{7})([0-9A-J])$");
    if(CIF_REGEX.hasMatch(document)){
      return true;
    }else{
      return false;
    }
  }

  static bool validateEmail(String email) {
    var EMAIL_REGEX = new RegExp(
        r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");
    if(EMAIL_REGEX.hasMatch(email)){
      return true;
    }else{
      return false;
    }
  }
}
