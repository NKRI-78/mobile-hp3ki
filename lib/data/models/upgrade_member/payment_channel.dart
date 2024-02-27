// ignore_for_file: constant_identifier_names
import 'package:equatable/equatable.dart';

class PaymentChannelModel {
  int? status;
  bool? error;
  String? message;
  List<PaymentChannelData>? data;

  PaymentChannelModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory PaymentChannelModel.fromJson(Map<String, dynamic> json) =>
      PaymentChannelModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<PaymentChannelData>.from(
            json["data"].map((x) => PaymentChannelData.fromJson(x))),
      );
}

class PaymentChannelData extends Equatable {
  final int? id;
  final DateTime? created;
  final int? status;
  final DateTime? updated;
  final int? adminFee;
  final Category? category;
  final String? paymentCode;
  final String? paymentDescription;
  final PaymentGateway? paymentGateway;
  final PaymentGuide? paymentGuide;
  final String? paymentLogo;
  final String? paymentName;
  final PaymentUrl? paymentUrl;
  final int? totalAdminFee;
  final int? minAmount;
  final PaymentMethod? paymentMethod;

  const PaymentChannelData({
    this.id,
    this.created,
    this.status,
    this.updated,
    this.adminFee,
    this.category,
    this.paymentCode,
    this.paymentDescription,
    this.paymentGateway,
    this.paymentGuide,
    this.paymentLogo,
    this.paymentName,
    this.paymentUrl,
    this.totalAdminFee,
    this.minAmount,
    this.paymentMethod,
  });

  factory PaymentChannelData.fromJson(Map<String, dynamic> json) =>
      PaymentChannelData(
        id: json["id"],
        created: DateTime.parse(json["created"]),
        status: json["status"],
        updated: DateTime.parse(json["updated"]),
        adminFee: json["admin_fee"],
        category: categoryValues.map[json["category"]],
        paymentCode: json["payment_code"],
        paymentDescription: json["payment_description"],
        paymentGateway: paymentGatewayValues.map[json["payment_gateway"]],
        paymentGuide: paymentGuideValues.map[json["payment_guide"]],
        paymentLogo: json["payment_logo"],
        paymentName: json["payment_name"],
        paymentUrl: paymentUrlValues.map[json["payment_url"]],
        totalAdminFee: json["total_admin_fee"],
        minAmount: json["min_amount"],
        paymentMethod: paymentMethodValues.map[json["payment_method"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created": created?.toIso8601String(),
        "status": status,
        "updated": updated?.toIso8601String(),
        "admin_fee": adminFee,
        "category": categoryValues.reverse[category],
        "payment_code": paymentCode,
        "payment_description": paymentDescription,
        "payment_gateway": paymentGatewayValues.reverse[paymentGateway],
        "payment_guide": paymentGuideValues.reverse[paymentGuide],
        "payment_logo": paymentLogo,
        "payment_name": paymentName,
        "payment_url": paymentUrlValues.reverse[paymentUrl],
        "total_admin_fee": totalAdminFee,
        "min_amount": minAmount,
        "payment_method": paymentMethodValues.reverse[paymentMethod],
      };

  @override
  List<Object?> get props => [
        id,
        created,
        status,
        updated,
        adminFee,
        category,
        paymentCode,
        paymentDescription,
        paymentGateway,
        paymentGuide,
        paymentLogo,
        paymentName,
        paymentUrl,
        totalAdminFee,
        minAmount,
        paymentMethod,
      ];
}

enum Category { VIRTUAL_ACCOUNT, E_WALLET, PAYMENT_LINK }

final categoryValues = EnumValues({
  "e-wallet": Category.E_WALLET,
  "payment link": Category.PAYMENT_LINK,
  "virtual account": Category.VIRTUAL_ACCOUNT
});

enum PaymentGateway { OYI, MIDTRANS, XENDIT }

final paymentGatewayValues = EnumValues({
  "midtrans": PaymentGateway.MIDTRANS,
  "oyi": PaymentGateway.OYI,
  "xendit": PaymentGateway.XENDIT
});

enum PaymentGuide { NOT_AVAILABLE }

final paymentGuideValues =
    EnumValues({"not available": PaymentGuide.NOT_AVAILABLE});

enum PaymentMethod { BANK_TRANSFER, E_WALLET, PAYMENT_LINK }

final paymentMethodValues = EnumValues({
  "BANK_TRANSFER": PaymentMethod.BANK_TRANSFER,
  "E_WALLET": PaymentMethod.E_WALLET,
  "PAYMENT_LINK": PaymentMethod.PAYMENT_LINK
});

enum PaymentUrl { NULL }

final paymentUrlValues = EnumValues({"NULL": PaymentUrl.NULL});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
