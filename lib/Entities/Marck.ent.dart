
class Marck  {

  final String id ;
  final String name;
  final double lat;
  final double long;

  Marck(
      this.id,
      this.name,
      this.lat,
      this.long);


  factory Marck.fromJson(Map<String, dynamic> json) {
    return Marck(json['id'],json['name'],double.parse(json['lat']),double.parse(json['long']),
    );
  }

}