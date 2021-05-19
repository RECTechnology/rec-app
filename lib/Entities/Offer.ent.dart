class Offer {
  final int id;
  final String description;
  final String discount;
  final String image;

  Offer({this.id, this.description, this.discount, this.image});

  factory Offer.fromJson(Map<String, dynamic> json) {
    var data = Offer(
      id: json['id'],
      description: json['description'],
      discount: json['discount'],
      image: json['image'],
    );
    return data;
  }
}
