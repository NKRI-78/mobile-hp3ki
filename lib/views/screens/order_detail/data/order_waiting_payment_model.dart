// To parse this JSON data, do
//
//     final orderWaitingPayment = orderWaitingPaymentFromJson(jsonString);

import 'dart:convert';

OrderWaitingPayment orderWaitingPaymentFromJson(String str) =>
    OrderWaitingPayment.fromJson(json.decode(str));

String orderWaitingPaymentToJson(OrderWaitingPayment data) =>
    json.encode(data.toJson());

class OrderWaitingPayment {
  int id;
  String paymentId;
  String userId;
  String paymentMethod;
  String paymentName;
  String paymentCode;
  int paymentFee;
  String paymentUrl;
  String paymentGuide;
  String paymentGuideUrl;
  String paymentNoVa;
  int amount;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  int productCount;
  String? productPicture;
  String productName;

  OrderWaitingPayment({
    required this.id,
    required this.paymentId,
    required this.userId,
    required this.paymentMethod,
    required this.paymentName,
    required this.paymentCode,
    required this.paymentFee,
    required this.paymentUrl,
    required this.paymentGuide,
    required this.paymentGuideUrl,
    required this.paymentNoVa,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.productCount,
    this.productPicture,
    required this.productName,
  });

  factory OrderWaitingPayment.fromJson(Map<String, dynamic> json) =>
      OrderWaitingPayment(
        id: json["id"],
        paymentId: json["payment_id"],
        userId: json["user_id"],
        paymentMethod: json["payment_method"],
        paymentName: json["payment_name"],
        paymentCode: json["payment_code"],
        paymentFee: json["payment_fee"],
        paymentUrl: json["payment_url"],
        paymentGuide: json["payment_guide"],
        paymentGuideUrl: json["payment_guide_url"],
        paymentNoVa: json["payment_no_va"],
        amount: json["amount"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        productCount: json["product_count"],
        productPicture: json["product_picture"],
        productName: json["product_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_id": paymentId,
        "user_id": userId,
        "payment_method": paymentMethod,
        "payment_name": paymentName,
        "payment_code": paymentCode,
        "payment_fee": paymentFee,
        "payment_url": paymentUrl,
        "payment_guide": paymentGuide,
        "payment_guide_url": paymentGuideUrl,
        "payment_no_va": paymentNoVa,
        "amount": amount,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product_count": productCount,
        "product_picture": productPicture,
        "product_name": productName,
      };
}
