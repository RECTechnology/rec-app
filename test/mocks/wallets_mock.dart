import 'package:rec/Entities/Currency.ent.dart';
import 'package:rec/Entities/Wallet.ent.dart';

class WalletsMock {
  static Wallet walletRec = Wallet.fromJson({
    'currency': Currency.rec,
    'balance': 0,
  });
  static Wallet walletEur = Wallet.fromJson({
    'currency': Currency.eur,
    'balance': 0,
  });
}
