// To parse this JSON data, do
//
//     final checkoutResponseModel = checkoutResponseModelFromJson(jsonString);

import 'dart:convert';

CheckoutResponseModel checkoutResponseModelFromJson(String str) =>
    CheckoutResponseModel.fromJson(json.decode(str));

String checkoutResponseModelToJson(CheckoutResponseModel data) =>
    json.encode(data.toJson());

class CheckoutResponseModel {
  Payments payments;
  PaymentMethod paymentMethod;

  CheckoutResponseModel({
    required this.payments,
    required this.paymentMethod,
  });

  factory CheckoutResponseModel.fromJson(Map<String, dynamic> json) =>
      CheckoutResponseModel(
        payments: Payments.fromJson(json["payments"]),
        paymentMethod: PaymentMethod.fromJson(json["payment_method"]),
      );

  Map<String, dynamic> toJson() => {
        "payments": payments.toJson(),
        "payment_method": paymentMethod.toJson(),
      };
}

class PaymentMethod {
  String channel;
  String category;
  String guide;
  int minAmount;
  String name;
  String paymentCode;
  String paymentDescription;
  String paymentGateway;
  String paymentLogo;
  String paymentMethod;
  String paymentName;
  dynamic paymentUrl;
  int totalAdminFee;
  String classId;
  bool isDirect;
  dynamic paymentUrlV2;

  PaymentMethod({
    required this.channel,
    required this.category,
    required this.guide,
    required this.minAmount,
    required this.name,
    required this.paymentCode,
    required this.paymentDescription,
    required this.paymentGateway,
    required this.paymentLogo,
    required this.paymentMethod,
    required this.paymentName,
    required this.paymentUrl,
    required this.totalAdminFee,
    required this.classId,
    required this.isDirect,
    required this.paymentUrlV2,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        channel: json["channel"],
        category: json["category"],
        guide: json["guide"],
        minAmount: json["minAmount"],
        name: json["name"],
        paymentCode: json["payment_code"],
        paymentDescription: json["payment_description"],
        paymentGateway: json["payment_gateway"],
        paymentLogo: json["payment_logo"],
        paymentMethod: json["payment_method"],
        paymentName: json["payment_name"],
        paymentUrl: json["payment_url"],
        totalAdminFee: json["total_admin_fee"],
        classId: json["classId"],
        isDirect: json["is_direct"],
        paymentUrlV2: json["payment_url_v2"],
      );

  Map<String, dynamic> toJson() => {
        "channel": channel,
        "category": category,
        "guide": guide,
        "minAmount": minAmount,
        "name": name,
        "payment_code": paymentCode,
        "payment_description": paymentDescription,
        "payment_gateway": paymentGateway,
        "payment_logo": paymentLogo,
        "payment_method": paymentMethod,
        "payment_name": paymentName,
        "payment_url": paymentUrl,
        "total_admin_fee": totalAdminFee,
        "classId": classId,
        "is_direct": isDirect,
        "payment_url_v2": paymentUrlV2,
      };
}

class Payments {
  String paymentId;
  String userId;
  String paymentMethod;
  String paymentName;
  String paymentCode;
  int paymentFee;
  int amount;
  String status;
  String paymentUrl;
  String paymentGuideUrl;
  String paymentGuide;
  String paymentNoVa;
  DateTime? createdAt;

  Payments(
      {required this.paymentId,
      required this.userId,
      required this.paymentMethod,
      required this.paymentName,
      required this.paymentCode,
      required this.paymentFee,
      required this.amount,
      required this.status,
      required this.paymentUrl,
      required this.paymentGuideUrl,
      required this.paymentGuide,
      required this.paymentNoVa,
      this.createdAt});

  factory Payments.fromJson(Map<String, dynamic> json) => Payments(
        paymentId: json["payment_id"],
        userId: json["user_id"],
        paymentMethod: json["payment_method"],
        paymentName: json["payment_name"],
        paymentCode: json["payment_code"],
        paymentFee: json["payment_fee"],
        amount: json["amount"],
        status: json["status"],
        paymentUrl: json["payment_url"],
        paymentGuideUrl: json["payment_guide_url"],
        paymentGuide: json["payment_guide"],
        paymentNoVa: json["payment_no_va"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "payment_id": paymentId,
        "user_id": userId,
        "payment_method": paymentMethod,
        "payment_name": paymentName,
        "payment_code": paymentCode,
        "payment_fee": paymentFee,
        "amount": amount,
        "status": status,
        "payment_url": paymentUrl,
        "payment_guide_url": paymentGuideUrl,
        "payment_guide": paymentGuide,
        "payment_no_va": paymentNoVa,
      };
}
