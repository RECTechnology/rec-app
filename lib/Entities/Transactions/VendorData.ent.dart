class VendorData {
  String name;
  String image;
  String type;

  VendorData({
    this.name = '',
    this.image,
    this.type,
  });

  VendorData.fromJson(dynamic data) {
    name = data['name'];
    image = data['company_image'];
    type = data['type'];
  }
}
