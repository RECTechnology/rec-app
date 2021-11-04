class Prefixes {
  static const ES = '+34';
  static const UK = '+44';
}

final numericRegExp = RegExp(r'^[0-9\-]+$');

abstract class PhoneValidatorStrategy {
  String validate(String phone);
}

/// Validator for spanish phone numbers
class EsPhoneValidator extends PhoneValidatorStrategy {
  final int _esPhoneLength = 9;

  @override
  String validate(String phone) {
    if (phone.length != _esPhoneLength) {
      return 'ERROR_PHONE';
    }

    if (!numericRegExp.hasMatch(phone)) {
      return 'ERROR_PHONE_BAD_CHARACTERS';
    }

    if (!phone.startsWith(RegExp(r'[67]'))) {
      return 'ERROR_PHONE_MUST_START_WITH';
    }

    return null;
  }
}

/// Validator that test if is a valid numeric string
class DefaultValidator extends PhoneValidatorStrategy {
  @override
  String validate(String phone) {
    if (!numericRegExp.hasMatch(phone)) {
      return 'ERROR_PHONE_BAD_CHARACTERS';
    }

    return null;
  }
}

// Instantiate validators
final esPhoneValidator = EsPhoneValidator();
final emptyPhoneValidator = DefaultValidator();

class PhoneValidator {
  PhoneValidator({String prefix}) : _prefix = prefix;

  String _prefix = '';

  void setPrefix(String prefix) {
    _prefix = prefix;
  }

  PhoneValidatorStrategy _getStrategy(String prefix) {
    if (prefix == Prefixes.ES) {
      return esPhoneValidator;
    }

    return emptyPhoneValidator;
  }

  String validate(String phoneNumber) {
    var strategy = _getStrategy(_prefix);

    return strategy.validate(phoneNumber);
  }
}
