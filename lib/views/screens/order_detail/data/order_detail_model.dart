// To parse this JSON data, do
//
//     final orderDetailModel = orderDetailModelFromJson(jsonString);

import 'dart:convert';

OrderDetailModel orderDetailModelFromJson(String str) =>
    OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) =>
    json.encode(data.toJson());

class OrderDetailModel {
  Order order;
  List<OrderItem> orderItems;

  OrderDetailModel({
    required this.order,
    required this.orderItems,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailModel(
        order: Order.fromJson(json["order"]),
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order": order.toJson(),
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class Order {
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
  String? shippingTracking;
  String status;
  dynamic finishDate;
  DateTime createdAt;
  DateTime updatedAt;
  String buyerId;
  String paymentMethod;
  String paymentName;
  int paymentFee;
  String paymentUrl;
  String paymentStatus;
  String buyerName;
  String buyerAvatar;
  String sellerName;
  String sellerAvatar;
  String storeName;
  String storePhone;
  String receiverPhone;
  String storePicture;
  String storeLng;
  String storeLat;

  Order({
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
    required this.buyerId,
    required this.paymentMethod,
    required this.paymentName,
    required this.paymentFee,
    required this.paymentUrl,
    required this.paymentStatus,
    required this.buyerName,
    required this.buyerAvatar,
    required this.sellerName,
    required this.sellerAvatar,
    required this.storeName,
    required this.storePicture,
    required this.storeLng,
    required this.storeLat,
    required this.storePhone,
    required this.receiverPhone,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
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
        shippingTracking: json["shipping_tracking"],
        status: json["status"],
        finishDate: json["finish_date"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        buyerId: json["buyerId"],
        paymentMethod: json["payment_method"],
        paymentName: json["payment_name"],
        paymentFee: json["payment_fee"],
        paymentUrl: json["payment_url"],
        paymentStatus: json["payment_status"],
        buyerName: json["buyer_name"],
        buyerAvatar: json["buyer_avatar"],
        sellerName: json["seller_name"],
        sellerAvatar: json["seller_avatar"],
        storeName: json["store_name"],
        storePhone: json["store_phone"] ?? '',
        storePicture: json["store_picture"],
        storeLng: json["store_lng"],
        storeLat: json["store_lat"],
        receiverPhone: json["receiver_phone"] ?? '',
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
        "buyerId": buyerId,
        "payment_method": paymentMethod,
        "payment_name": paymentName,
        "payment_fee": paymentFee,
        "payment_url": paymentUrl,
        "payment_status": paymentStatus,
        "buyer_name": buyerName,
        "buyer_avatar": buyerAvatar,
        "seller_name": sellerName,
        "seller_avatar": sellerAvatar,
        "store_name": storeName,
        "store_picture": storePicture,
        "store_lng": storeLng,
        "store_lat": storeLat,
        "store_phone": storePhone,
        "receiver_phone": receiverPhone,
      };
}

class OrderItem {
  String prdouctId;
  String productName;
  String productDescription;
  int productStock;
  String? productPicture;
  int orderItemQuantity;
  int orderItemPrice;
  int orderItemWeight;
  dynamic orderItemStatus;
  String orderItemNote;

  OrderItem({
    required this.prdouctId,
    required this.productName,
    required this.productDescription,
    required this.productStock,
    required this.productPicture,
    required this.orderItemQuantity,
    required this.orderItemPrice,
    required this.orderItemWeight,
    required this.orderItemStatus,
    required this.orderItemNote,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productName: json["product_name"],
        productDescription: json["product_description"],
        productStock: json["product_stock"],
        productPicture: json["product_picture"],
        orderItemQuantity: json["order_item_quantity"],
        orderItemPrice: json["order_item_price"],
        orderItemWeight: json["order_item_weight"],
        orderItemStatus: json["order_item_status"],
        orderItemNote: json["order_item_note"],
        prdouctId: json["product_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_description": productDescription,
        "product_stock": productStock,
        "product_picture": productPicture,
        "order_item_quantity": orderItemQuantity,
        "order_item_price": orderItemPrice,
        "order_item_weight": orderItemWeight,
        "order_item_status": orderItemStatus,
        "order_item_note": orderItemNote,
        "prdouct_id": prdouctId,
      };
}
