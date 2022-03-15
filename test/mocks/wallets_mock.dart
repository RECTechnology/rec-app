import 'package:rec_api_dart/rec_api_dart.dart';

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
