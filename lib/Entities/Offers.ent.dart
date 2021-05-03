class OffersData {
  final int id;

  final String description;
  final String discount;
  final String avatarImage;

  OffersData(this.id, this.description,this.discount, this.avatarImage);

  factory OffersData.fromJson(Map<String, dynamic> json) {
    var data = OffersData(
      json['id'],
      json['description'],
      json['discount'],
      json['image'],

    );
    return data;
  }
}
