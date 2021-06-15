class PayOutInfo {
  String address;
  String txId;
  String status;
  String image;
  String name;
  String concept;

  int amount;

  bool isFinal;

  PayOutInfo({
    this.address,
    this.amount,
    this.txId,
    this.status,
    this.isFinal,
    this.image,
    this.name,
    this.concept,
  });

  factory PayOutInfo.fromJson(Map<String, dynamic> json) {
    return PayOutInfo(
      address: json['address'],
      amount: double.parse('${json['amount']}').toInt(),
      concept: json['concept'] ?? '',
      txId: json['txid'],
      status: json['status'],
      isFinal: json['final'],
      image: json['image_receiver'],
      name: json['name_receiver'],
    );
  }
}
