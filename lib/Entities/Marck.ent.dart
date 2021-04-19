class Marck {
  final int id;

  final String name;
  final double lat;
  final double long;

  Marck(this.id, this.name, this.lat, this.long);

  // ignore: missing_return
  factory Marck.fromJson(Map<String, dynamic> json) {

    var marck = Marck(
        json['id'],
        json['name'],
        double.parse(json['latitude'].toString()),
        double.parse(json['longitude'].toString()));

    return marck;
  }
}
