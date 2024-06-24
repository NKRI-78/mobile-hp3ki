import 'package:equatable/equatable.dart';

class InquiryModel {
  int? status;
  bool? error;
  String? message;
  InquiryData? data;

  InquiryModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) => InquiryModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: json["data"] == null ? null : InquiryData.fromJson(json["data"]),
      );
}

class InquiryData extends Equatable {
  final DateTime? expired;
  final String? noVa;
  final String? totalPayment;
  final String? paymentGuide;
  final String? paymentChannel;
  final List<Detail>? detail;

  const InquiryData({
    this.expired,
    this.noVa,
    this.totalPayment,
    this.paymentGuide,
    this.paymentChannel,
    this.detail,
  });

  factory InquiryData.fromJson(Map<String, dynamic> json) => InquiryData(
        expired:
            json["expired"] == null ? null : DateTime.parse(json["expired"]),
        noVa: json["no_va"],
        totalPayment: json["total_payment"],
        paymentGuide: json["payment_guide"],
        paymentChannel: json["payment_channel"],
        detail: json["detail"] == null
            ? []
            : List<Detail>.from(json["detail"]!.map((x) => Detail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "expired": expired?.toIso8601String(),
        "no_va": noVa,
        "total_payment": totalPayment,
        "payment_guide": paymentGuide,
        "payment_channel": paymentChannel,
        "detail": detail == null
            ? []
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        expired,
        noVa,
        totalPayment,
        paymentGuide,
        paymentChannel,
        detail,
      ];
}

class Detail extends Equatable {
  final String? name;

  const Detail({
    this.name,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };

  @override
  List<Object?> get props => [
        name,
      ];
}
