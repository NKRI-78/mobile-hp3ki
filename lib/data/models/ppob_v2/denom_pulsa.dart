import 'package:equatable/equatable.dart';

class DenomPulsaModel {
  int? code;
  dynamic error;
  String? message;
  List<DenomPulsaData>? body;

  DenomPulsaModel({
    this.code,
    this.error,
    this.message,
    this.body,
  });

  factory DenomPulsaModel.fromJson(Map<String, dynamic> json) => DenomPulsaModel(
    code: json["code"],
    error: json["error"],
    message: json["message"],
    body: List<DenomPulsaData>.from(json["body"].map((x) => DenomPulsaData.fromJson(x))),
  );
}

class DenomPulsaData extends Equatable{
  final String productCode;
  final  int productPrice;
  final  int productFee;
  final String productName;

  const DenomPulsaData({
    required this.productCode,
    required this.productPrice,
    required this.productFee,
    required this.productName,
  });

  factory DenomPulsaData.fromJson(Map<String, dynamic> json) => DenomPulsaData(
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
