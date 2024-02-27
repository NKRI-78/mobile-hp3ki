import 'package:equatable/equatable.dart';

class PaymentListModel {
  final int? code;
  final dynamic error;
  final String? message;
  final List<PaymentListData>? body;

  PaymentListModel({
    this.code,
    this.error,
    this.message,
    this.body,
  });

  factory PaymentListModel.fromJson(Map<String, dynamic> json) =>
      PaymentListModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        body: json["body"] == null
            ? []
            : List<PaymentListData>.from(
                json["body"]!.map((x) => PaymentListData.fromJson(x))),
      );
}

class PaymentListData extends Equatable {
  final String? channel;
  final String? category;
  final String? guide;
  final int? minAmount;
  final String? name;
  final String? paymentCode;
  final String? paymentDescription;
  final String? paymentGateway;
  final String? paymentLogo;
  final String? paymentMethod;
  final String? paymentName;
  final String? paymentUrl;
  final int? totalAdminFee;
  final String? classId;
  final bool? isDirect;
  final dynamic paymentUrlV2;

  const PaymentListData({
    this.channel,
    this.category,
    this.guide,
    this.minAmount,
    this.name,
    this.paymentCode,
    this.paymentDescription,
    this.paymentGateway,
    this.paymentLogo,
    this.paymentMethod,
    this.paymentName,
    this.paymentUrl,
    this.totalAdminFee,
    this.classId,
    this.isDirect,
    this.paymentUrlV2,
  });

  factory PaymentListData.fromJson(Map<String, dynamic> json) =>
      PaymentListData(
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

  @override
  List<Object?> get props => [
        channel,
        category,
        guide,
        minAmount,
        name,
        paymentCode,
        paymentDescription,
        paymentGateway,
        paymentLogo,
        paymentMethod,
        paymentName,
        paymentUrl,
        totalAdminFee,
        classId,
        isDirect,
        paymentUrlV2,
      ];
}
