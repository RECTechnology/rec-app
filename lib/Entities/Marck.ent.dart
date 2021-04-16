
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
    print("Im in from json");
    print(json);
    print(json['latitude']);
    print(json['longitude']);
    return Marck(json['id'],json['name'],double.parse(json['latitude']),double.parse(json['longitude']),
    );
  }

}