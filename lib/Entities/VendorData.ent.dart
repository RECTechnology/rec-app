class VendorData {
  String name;
  String image;
  String type;

  VendorData({
    this.name = '',
    this.image,
    this.type,
  });

  VendorData.fromJson(List<dynamic> data) {
    name = data[0];
    image = data[1];
    type = data[2];
  }
}
