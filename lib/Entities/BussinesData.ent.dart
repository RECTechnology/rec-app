class BussinesData {
  final int id;

  final String name;
  final String description;
  final String imageURL;
  final String avatarImage;
  final String prefix;
  final String phone;
  final List offers;
  final String street;
  final String webURL;
  final String schedule;
  final String latitude;
  final String longitude;
  BussinesData(this.id, this.name, this.description, this.imageURL,this.avatarImage,this.phone,this.prefix,this.offers,this.street,this.webURL,this.schedule,this.latitude,this.longitude);

  factory BussinesData.fromJson(Map<String, dynamic> json) {
    var data = BussinesData(
      json['id'],
      json['name'],
      json['description'],
      json['public_image'],
      json['image'],
      json['prefix'],
      json['phone'],
      json['offers'],
      'Calle '+ json['street']+', '+json['address_number']+', '+json['zip'],
      json['web'],
      json['schedule'],
      json['latitude'],
      json['longitude'],
    );

    return data;
  }
}
