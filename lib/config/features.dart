class Features {
  static String get cultureActivityName => 'Culture';
  static List<String> uneditableAccountNames = ['REC Cultural'];

  static bool get contactList {
    return false;
  }

  static bool get imageUploads {
    return false;
  }

  static bool get refunds {
    return true;
  }

  static bool get newTxModal {
    return true;
  }

  static int get offerDescriptionMaxChars {
    return 80;
  }
}
