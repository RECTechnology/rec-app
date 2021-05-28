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

  static String capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
