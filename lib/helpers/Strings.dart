class Strings {
  static String interpolate(
    String string, {
    Map<String, dynamic> params = const {},
  }) {
    var keys = params.keys;
    var result = string;

    for (var key in keys) {
      result = result.replaceAll('{{$key}}', '${params[key]}');
    }

    return result;
  }

  static String capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static String capitalizeWords(String input) {
    final List<String> splitStr = input.split(' ');

    for (int i = 0; i < splitStr.length; i++) {
      splitStr[i] = '${splitStr[i][0].toUpperCase()}${splitStr[i].substring(1)}';
    }

    final output = splitStr.join(' ');

    return output;
  }
}
