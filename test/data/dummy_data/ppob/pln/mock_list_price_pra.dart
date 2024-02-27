import 'package:hp3ki/data/models/ppob_v2/pln/list_price_pra.dart';

class MockListPricePraBayar {
  static const ListPricePraBayarData expectedListPricePraBayarData = ListPricePraBayarData(
    productCode: "4Ny",
    productPrice: 9999,
    productFee: 999,
    productName: "Testing",
  );

  static final Map<String, dynamic> dummyListPricePraBayarJson =
      expectedListPricePraBayarData.toJson();

  static final Map<String, dynamic> expectedResponseModel = {
    "status": 200,
    "error": false,
    "message": "Ok",
    "body": [dummyListPricePraBayarJson],
  };
}
