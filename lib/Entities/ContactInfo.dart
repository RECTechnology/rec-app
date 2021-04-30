class ContactInfo {
  final String phone;
  final String account;
  final String address;
  final String image;
  final bool isMyAccount;

  ContactInfo({
    this.phone,
    this.account,
    this.address,
    this.image,
    this.isMyAccount,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      phone: json['phone'],
      account: json['account'],
      address: json['address'],
      image: json['image'],
      isMyAccount: (json['is_my_account'] == 1),
    );
  }
}
