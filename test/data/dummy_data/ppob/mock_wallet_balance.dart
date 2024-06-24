import 'package:hp3ki/data/models/ppob_v2/wallet_balance.dart';

class MockWalletBalance {
  static const WalletBalanceData expectedWalletBalanceData = WalletBalanceData(
    balance: 10000,
  );

  static final Map<String, dynamic> dummyWalletBalanceJson =
      expectedWalletBalanceData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "body": dummyWalletBalanceJson,
  };
}
