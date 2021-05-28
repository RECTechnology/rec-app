/// Class containg a set of methods that help with checking common conditions
class Checks {
  /// Checks if an element is `null`
  static bool isNull(dynamic element) {
    return element == null;
  }

  /// Checks if an element is not `null`
  static bool isNotNull(dynamic element) {
    return element != null;
  }

  /// Checks if a value is not `null` and is not empty
  static bool isNotEmpty(dynamic element) {
    return isNotNull(element) && element.isNotEmpty;
  }

  /// Checks if a value is not `null` and is empty
  static bool isEmpty(dynamic element) {
    return isNotNull(element) && element.isEmpty;
  }
}
