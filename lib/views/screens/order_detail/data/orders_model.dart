// To parse this JSON data, do
//
//     final ordersModel = ordersModelFromJson(jsonString);

import 'dart:convert';

OrdersModel ordersModelFromJson(String str) =>
    OrdersModel.fromJson(json.decode(str));

String ordersModelToJson(OrdersModel data) => json.encode(data.toJson());

class OrdersModel {
  int total;
  int perPage;
  int nextPage;
  int prevPage;
  int currentPage;
  String nextUrl;
  String prevUrl;
  List<OrderData> data;

  OrdersModel({
    required this.total,
    required this.perPage,
    required this.nextPage,
    required this.prevPage,
    required this.currentPage,
    required this.nextUrl,
    required this.prevUrl,
    required this.data,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        total: json["total"],
        perPage: json["per_page"],
        nextPage: json["next_page"],
        prevPage: json["prev_page"],
        currentPage: json["current_page"],
        nextUrl: json["next_url"],
        prevUrl: json["prev_url"],
        data: List<OrderData>.from(
            json["data"].map((x) => OrderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "per_page": perPage,
        "next_page": nextPage,
        "prev_page": prevPage,
        "current_page": currentPage,
        "next_url": nextUrl,
        "prev_url": prevUrl,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class OrderData {
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

  OrderData({
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

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
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
