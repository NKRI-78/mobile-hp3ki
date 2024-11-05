class PaymentChannelModel {
  int status;
  bool error;
  String message;
  List<PaymentChannelData> data;

  PaymentChannelModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory PaymentChannelModel.fromJson(Map<String, dynamic> json) => PaymentChannelModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<PaymentChannelData>.from(json["data"].map((x) => PaymentChannelData.fromJson(x))),
  );
}

class PaymentChannelData {
  int id;
  String paymentType;
  String name;
  String nameCode;
  String? logo;
  String platform;
  int? fee;
  dynamic serviceFee;
  dynamic howToUseUrl;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;

  PaymentChannelData({
    required this.id,
    required this.paymentType,
    required this.name,
    required this.nameCode,
    required this.logo,
    required this.platform,
    required this.fee,
    required this.serviceFee,
    required this.howToUseUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory PaymentChannelData.fromJson(Map<String, dynamic> json) => PaymentChannelData(
    id: json["id"],
    paymentType: json["paymentType"],
    name: json["name"],
    nameCode: json["nameCode"],
    logo: json["logo"],
    platform: json["platform"],
    fee: json["fee"],
    serviceFee: json["service_fee"],
    howToUseUrl: json["howToUseUrl"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"] == null ? null : DateTime.parse(json["deletedAt"]),
  );
}
