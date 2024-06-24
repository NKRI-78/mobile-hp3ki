import 'package:equatable/equatable.dart';

class ListPricePraBayarModel {
    int? code;
    dynamic error;
    String? message;
    List<ListPricePraBayarData>? body;

    ListPricePraBayarModel({
        this.code,
        this.error,
        this.message,
        this.body,
    });

    factory ListPricePraBayarModel.fromJson(Map<String, dynamic> json) => ListPricePraBayarModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        body: List<ListPricePraBayarData>.from(json["body"].map((x) => ListPricePraBayarData.fromJson(x))),
    );
}

class ListPricePraBayarData extends Equatable{
    final String? productCode;
    final int? productPrice;
    final int? productFee;
    final String? productName;

    const ListPricePraBayarData({
        this.productCode,
        this.productPrice,
        this.productFee,
        this.productName,
    });

    factory ListPricePraBayarData.fromJson(Map<String, dynamic> json) => ListPricePraBayarData(
        productCode: json["product_code"],
        productPrice: json["product_price"],
        productFee: json["product_fee"],
        productName: json["product_name"],
    );

      Map<String, dynamic> toJson() => {
        "product_code": productCode,
        "product_price": productPrice,
        "product_fee": productFee,
        "product_name": productName,
      };

  @override
  List<Object?> get props => [
    productCode,
    productPrice,
    productFee,
    productName,
  ];

}
