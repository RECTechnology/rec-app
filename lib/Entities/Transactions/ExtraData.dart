class ExtraData {
  int rewardedLtabAmount;

  ExtraData({
    this.rewardedLtabAmount,
  });

  factory ExtraData.fromJson(Map<String, dynamic> json) {
    return ExtraData(rewardedLtabAmount: json['rewarded_ltab']);
  }
}
