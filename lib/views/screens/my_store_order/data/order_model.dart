// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  int id;
  String orderId;
  String paymentId;
  String storeId;
  int amount;
  int shippingAmount;
  String shippingCode;
  String shippingName;
  String shippingAddress;
  String shippingAddressDetail;
  String shippingTracking;
  String status;
  dynamic finishDate;
  DateTime createdAt;
  DateTime updatedAt;
  int productCount;
  String? productPicture;
  String productName;
  String paymentName;
  int paymentFee;
  String buyerName;
  String storeName;

  OrderModel({
    required this.id,
    required this.orderId,
    required this.paymentId,
    required this.storeId,
    required this.amount,
    required this.shippingAmount,
    required this.shippingCode,
    required this.shippingName,
    required this.shippingAddress,
    required this.shippingAddressDetail,
    required this.shippingTracking,
    required this.status,
    required this.finishDate,
    required this.createdAt,
    required this.updatedAt,
    required this.productCount,
    this.productPicture,
    required this.productName,
    required this.paymentName,
    required this.paymentFee,
    required this.buyerName,
    required this.storeName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        orderId: json["order_id"],
        paymentId: json["payment_id"],
        storeId: json["store_id"],
        amount: json["amount"],
        shippingAmount: json["shipping_amount"],
        shippingCode: json["shipping_code"],
        shippingName: json["shipping_name"],
        shippingAddress: json["shipping_address"],
        shippingAddressDetail: json["shipping_address_detail"],
        shippingTracking: json["shipping_tracking"] ?? "",
        status: json["status"],
        finishDate: json["finish_date"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        productCount: json["product_count"] ?? 0,
        productPicture: json["product_picture"],
        paymentName: json["payment_name"],
        productName: json["product_name"],
        paymentFee: json["payment_fee"],
        buyerName: json["buyer_name"],
        storeName: json["store_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "payment_id": paymentId,
        "store_id": storeId,
        "amount": amount,
        "shipping_amount": shippingAmount,
        "shipping_code": shippingCode,
        "shipping_name": shippingName,
        "shipping_address": shippingAddress,
        "shipping_address_detail": shippingAddressDetail,
        "shipping_tracking": shippingTracking,
        "status": status,
        "finish_date": finishDate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product_count": productCount,
        "product_picture": productPicture,
        "payment_name": paymentName,
        "payment_fee": paymentFee,
        "buyer_name": buyerName,
        "store_name": storeName,
        "product_name": productName,
      };
}
