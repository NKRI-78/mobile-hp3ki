import 'package:equatable/equatable.dart';

class InquiryPLNPascabayarModel {
  InquiryPLNPascabayarModel({
    this.code,
    this.message,
    this.body,
    this.error,
  });

  int? code;
  String? message;
  InquiryPLNPascaBayarData? body;
  dynamic error;

  factory InquiryPLNPascabayarModel.fromJson(Map<String, dynamic> json) => InquiryPLNPascabayarModel(
    code: json["code"],
    message: json["message"],
    body: InquiryPLNPascaBayarData.fromJson(json["body"]),
    error: json["error"],
  );
}

class InquiryPLNPascaBayarData extends Equatable{
  const InquiryPLNPascaBayarData({
    this.inquiryStatus,
    this.productPrice,
    this.productId,
    this.productCode,
    this.productName,
    this.accountNumber1,
    this.accountNumber2,
    this.transactionId,
    this.transactionRef,
    this.data,
    this.classId,
  });

  final String? inquiryStatus;
  final dynamic productPrice;
  final String? productId;
  final String? productCode;
  final String? productName;
  final String? accountNumber1;
  final String? accountNumber2;
  final String? transactionId;
  final String? transactionRef;
  final InquiryPLNPascaBayarUserData? data;
  final String? classId;

  factory InquiryPLNPascaBayarData.fromJson(Map<String, dynamic> json) => InquiryPLNPascaBayarData(
    inquiryStatus: json["inquiryStatus"],
    productPrice: json["productPrice"] ?? "",
    productId: json["productId"],
    productCode: json["productCode"],
    productName: json["productName"],
    accountNumber1: json["accountNumber1"],
    accountNumber2: json["accountNumber2"],
    transactionId: json["transactionId"],
    transactionRef: json["transactionRef"],
    data: InquiryPLNPascaBayarUserData.fromJson(json["data"]),
    classId: json["classId"],
  );

    Map<String, dynamic> toJson() => {
      "inquiryStatus": inquiryStatus,
      "productPrice": productPrice,
      "productId": productId,
      "productCode": productCode,
      "productName": productName,
      "accountNumber1": accountNumber1,
      "accountNumber2": accountNumber2,
      "transactionId": transactionId,
      "transactionRef": transactionRef,
      "data": data?.toJson(),
      "classId": classId,
    };

  @override
  List<Object?> get props => [
    inquiryStatus,
    productPrice,
    productId,
    productCode,
    productName,
    accountNumber1,
    accountNumber2,
    transactionId,
    transactionId,
    data,
    classId,
  ];

}

class InquiryPLNPascaBayarUserData extends Equatable{
  const InquiryPLNPascaBayarUserData({
    this.amount,
    this.accountName,
    this.admin,
  });

  final dynamic amount;
  final String? accountName;
  final dynamic admin;

  factory InquiryPLNPascaBayarUserData.fromJson(Map<String, dynamic> json) => InquiryPLNPascaBayarUserData(
    amount: json["amount"] ?? "",
    accountName: json["accountName"],
    admin: json["admin"] ?? "",
  );

    Map<String, dynamic> toJson() => {
      "amount": amount,
      "accountName": accountName,
      "admin": admin,
    };

  @override
  List<Object?> get props => [
    amount,
    accountName,
    admin,
  ];

}
