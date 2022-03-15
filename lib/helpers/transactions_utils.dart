import 'package:rec/config/tx_concepts.dart';
import 'package:rec_api_dart/rec_api_dart.dart';

class TransactionHelper {
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

  static String? getConcept(Transaction tx) {
    if (isLtabReward(tx)) {
      return 'LTAB_REWARD';
    }

    if (isCultureReward(tx)) {
      return tx.payInInfo!.concept;
    }

    if (isRecharge(tx)) {
      return 'RECHARGE_EUR_REC';
    }

    if (tx.isOut()) {
      return tx.payOutInfo!.concept;
    }

    if (tx.isIn()) {
      return tx.payInInfo!.concept;
    }

    return 'NO_CONCEPT';
  }
}
