import 'package:rec/Entities/Transaction.ent.dart';

class TransactionMock {
  static Transaction transactionIn = Transaction.fromJson({
    'type': 'in',
    'amount': 1000,
    'total': 1000,
    'scale': 8,
    'method': TransactionMethod.REC,
    'pay_in_info': {
      'concept': 'test',
      'name_sender': 'test',
    },
  });
  static Transaction transactionOut = Transaction.fromJson({
    'type': 'out',
    'amount': 1000,
    'total': 1000,
    'scale': 8,
    'method': TransactionMethod.REC,
    'pay_out_info': {
      'concept': 'test',
      'name_receiver': 'test',
    },
  });
  static Transaction transactionRecharge = Transaction.fromJson({
    'type': 'in',
    'amount': 1000,
    'total': 1000,
    'scale': 8,
    'method': TransactionMethod.EUR,
    'pay_in_info': {
      // this concept is what identifies a transaction as a recharge
      'concept': 'Internal exchange',
      'name_sender': 'test',
    },
  });
}
