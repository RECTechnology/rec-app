class PayInInfo {
  int amount;
  int received;
  int scale;
  int expiresIn;
  int minComfirmations;
  int confimations;

  String currency;
  String address;
  String txId;
  String status;
  String concept;
  String imageSender;
  String nameSender;

  bool isFinal;

  PayInInfo({
    this.amount,
    this.received,
    this.scale,
    this.expiresIn,
    this.minComfirmations,
    this.confimations,
    this.currency,
    this.address,
    this.txId,
    this.status,
    this.concept,
    this.isFinal,
    this.imageSender,
    this.nameSender,
  });

  factory PayInInfo.fromJson(Map<String, dynamic> json) {
    return PayInInfo(
      amount: json['amount'],
      received: json['received'],
      scale: json['scale'],
      expiresIn: json['expires_in'],
      minComfirmations: json['min_comfirmations'],
      confimations: json['confimations'],
      currency: json['currency'],
      concept: json['concept'],
      address: json['address'],
      txId: json['txid'],
      status: json['status'],
      isFinal: json['final'],
      imageSender: json['image_sender'],
      nameSender: json['name_sender'],
    );
  }
}
