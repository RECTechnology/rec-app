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
  String paymentUrl;

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
    this.paymentUrl,
  });

  factory PayInInfo.fromJson(Map<String, dynamic> json) {
    return PayInInfo(
      // Api returns sometimes strings, and sometimes ints
      // Hack to not get error
      amount: int.parse('${json['amount']}'),
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
      paymentUrl: json['payment_url'],
    );
  }

  factory PayInInfo.fromJsonRecharge(Map<String, dynamic> json) {
    return PayInInfo(
      // Api returns sometimes strings, and sometimes ints
      // Hack to not get error
      amount: int.parse('${json['amount']}'),
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
      paymentUrl: json['payment_url'],
    );
  }
}
