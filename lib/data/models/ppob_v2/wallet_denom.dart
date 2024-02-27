import 'package:equatable/equatable.dart';

class WalletDenomModel {
  final int? code;
  dynamic error;
  final String? message;
  final WalletDenomBody? body;

  WalletDenomModel({
    this.code,
    this.error,
    this.message,
    this.body,
  });

  factory WalletDenomModel.fromJson(Map<String, dynamic> json) =>
      WalletDenomModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        body: json["body"] == null
            ? null
            : WalletDenomBody.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "error": error,
        "message": message,
        "body": body?.toJson(),
      };
}

class WalletDenomBody extends Equatable {
  final List<WalletDenomData>? data;

  const WalletDenomBody({
    this.data,
  });

  factory WalletDenomBody.fromJson(Map<String, dynamic> json) =>
      WalletDenomBody(
        data: json["data"] == null
            ? []
            : List<WalletDenomData>.from(
                json["data"]!.map((x) => WalletDenomData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props => [
        data,
      ];
}

class WalletDenomData extends Equatable {
  final String? id;
  final int? denom;

  const WalletDenomData({
    this.id,
    this.denom,
  });

  factory WalletDenomData.fromJson(Map<String, dynamic> json) =>
      WalletDenomData(
        id: json["id"],
        denom: json["denom"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "denom": denom,
      };

  @override
  List<Object?> get props => [
        id,
        denom,
      ];
}
