class ExtraData {
  int rewardedLtabAmount;

  ExtraData({
    this.rewardedLtabAmount,
  });

  factory ExtraData.fromJson(Map<String, dynamic> json) {
    return ExtraData(
      rewardedLtabAmount: double.parse('${json['rewarded_ltab']}').toInt(),
    );
  }
}
