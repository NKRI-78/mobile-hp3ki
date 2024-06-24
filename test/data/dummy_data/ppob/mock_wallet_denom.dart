import 'package:hp3ki/data/models/ppob_v2/wallet_denom.dart';

class MockWalletDenom {
  static const WalletDenomData expectedWalletDenomData = WalletDenomData(
    id: "addcbeaa-ae74-450e-a396-9b00c91474ab",
    denom: 10000,
  );

  static final Map<String, dynamic> dummyWalletDenomJson =
      expectedWalletDenomData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "body": {
      "data": [dummyWalletDenomJson],
    },
  };
}
