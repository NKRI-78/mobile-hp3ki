// To parse this JSON data, do
//
//     final paymentMethodModel = paymentMethodModelFromJson(jsonString);

import 'dart:convert';

PaymentMethodModel paymentMethodModelFromJson(String str) =>
    PaymentMethodModel.fromJson(json.decode(str));

String paymentMethodModelToJson(PaymentMethodModel data) =>
    json.encode(data.toJson());

class PaymentMethodModel {
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
  String paymentUrl;
  int totalAdminFee;
  String classId;
  bool isDirect;
  int status;
  dynamic paymentUrlV2;

  PaymentMethodModel({
    required this.channel,
    required this.status,
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

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        channel: json["channel"],
        status: json["status"] ?? 0,
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
        "status": status,
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
