import 'package:flutter_test/flutter_test.dart';
import 'package:rec/helpers/validators/phone_validator.dart';

void main() {
  test('PhoneValidator works with valid ES phones', () {
    var phoneValidator = PhoneValidator(prefix: Prefixes.ES);
    var validEsPhones = ['605450083', '765765789', '645123345'];

    for (var phone in validEsPhones) {
      expect(phoneValidator.validate(phone), null);
    }
  });

  test('PhoneValidator works with invalid ES phones', () {
    var phoneValidator = PhoneValidator(prefix: Prefixes.ES);
    var invalidEsPhones = ['321-345', '888999111', '123123123', '6bcdefghi'];

    var expectedErrors = [
      'ERROR_PHONE',
      'ERROR_PHONE_MUST_START_WITH',
      'ERROR_PHONE_BAD_CHARACTERS'
    ];

    for (var phone in invalidEsPhones) {
      var result = phoneValidator.validate(phone);
      expect(expectedErrors.contains(result), true);
    }
  });

  test('PhoneValidator works with non-ES phones', () {
    var phoneValidator = PhoneValidator(prefix: Prefixes.UK);
    var nonEsPhones = ['321-345', '888999111', '123123123'];

    for (var phone in nonEsPhones) {
      expect(phoneValidator.validate(phone), null);
    }
  });

  test('PhoneValidator works with invalid non-ES phones', () {
    var phoneValidator = PhoneValidator(prefix: Prefixes.UK);
    var nonEsPhones = ['', 'abcdef', 'dddfff777888'];

    for (var phone in nonEsPhones) {
      expect(phoneValidator.validate(phone), 'ERROR_PHONE_BAD_CHARACTERS');
    }
  });
}
