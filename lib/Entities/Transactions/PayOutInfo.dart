class PayOutInfo {
  String address;
  String txId;
  String status;
  String imageReceiver; //TODO: rename to image
  String nameReceiver;
  String concept;

  int amount;

  bool isFinal;

  PayOutInfo({
    this.address,
    this.amount,
    this.txId,
    this.status,
    this.isFinal,
    this.imageReceiver,
    this.nameReceiver,
    this.concept,
  });

  factory PayOutInfo.fromJson(Map<String, dynamic> json) {
    return PayOutInfo(
      address: json['address'],
      amount: json['amount'],
      concept: json['concept'] ?? '',
      txId: json['txid'],
      status: json['status'],
      isFinal: json['final'],
      imageReceiver: json['image_receiver'],
      nameReceiver: json['name_receiver'],
    );
  }
}
