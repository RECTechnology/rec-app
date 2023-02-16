import 'package:flutter/widgets.dart';
import 'package:rec/config/tx_concepts.dart';
import 'package:rec/providers/campaign_provider.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class TransactionHelper {
  static int sortByDate(Transaction t1, Transaction t2) {
    return t1.createdAt.compareTo(t2.createdAt);
  }

  static bool isLtabReward(Transaction tx) {
    return tx.isIn() &&
        tx.hasPayInInfo() &&
        tx.payInInfo!.concept == 'Internal exchange' &&
        tx.payInInfo!.name == 'LI TOCA AL BARRI';
  }

  static bool isCultureReward(Transaction tx) {
    return tx.isIn() && tx.hasPayInInfo() && tx.payInInfo!.concept!.startsWith(cultureTxConcept);
  }

  static bool isRecharge(Transaction tx) {
    return tx.isIn() && tx.hasPayInInfo() && tx.payInInfo!.concept!.startsWith(internalExchange);
  }

  static bool isChequeCulture(Transaction tx) {
    return tx.isIn() && tx.hasPayInInfo() && tx.payInInfo!.concept!.startsWith(chequeCultural);
  }

  static String? getConcept(Transaction tx, BuildContext context) {
    if (isCampaignReward(tx, context)) return tx.payInInfo!.concept;
    if (isLtabReward(tx)) return 'LTAB_REWARD';
    if (isCultureReward(tx)) return tx.payInInfo!.concept;
    if (isChequeCulture(tx)) return tx.payInInfo!.concept;
    if (isRecharge(tx)) return 'RECHARGE_EUR_REC';
    if (tx.isOut()) return tx.payOutInfo!.concept;
    if (tx.isIn()) return tx.payInInfo!.concept;

    return 'NO_CONCEPT';
  }

  static getPrefix(Transaction tx, Account account) {
    if (TransactionHelper.isRecharge(tx)) return 'FROM_CREDIT_CARD';
    if (TransactionHelper.isChequeCulture(tx)) return 'FROM';
    if (tx.isOut()) return 'TO';

    return 'FROM';
  }

  static getOwner(Transaction tx, Account account, BuildContext context) {
    if (tx.isIn() && account.isLtabAccount()) return 'LTAB';
    if (TransactionHelper.isCultureReward(tx)) return 'REC_CULTURAL';
    if (TransactionHelper.isChequeCulture(tx)) return 'REC_CULTURAL';
    if (isCampaignReward(tx, context)) return _createOwnerForCampaign(tx, context);
    if (TransactionHelper.isRecharge(tx)) return 'CREDIT_CARD_TX';
    if (tx.isOut()) return tx.payOutInfo!.name;
    if (tx.isIn()) return tx.payInInfo!.name;

    return 'PARTICULAR';
  }

  static bool isCampaignReward(Transaction tx, BuildContext context) {
    if (!tx.isBonification) return false;
    return true;
  }

  static _createOwnerForCampaign(Transaction tx, BuildContext context) {
    final campProv = CampaignProvider.deaf(context);
    final campaignId = tx.bonificationCampaignId;
    final campaign = campProv.getCampaignById('${campaignId!}');

    return campaign?.name != null && campaign!.name!.isNotEmpty ? campaign.name : 'CAMPAIGN';
  }
}
