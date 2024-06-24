import 'package:equatable/equatable.dart';

class WalletBalanceModel {
  final int? code;
  final dynamic error;
  final String? message;
  final WalletBalanceData? body;

  WalletBalanceModel({
    this.code,
    this.error,
    this.message,
    this.body,
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) =>
      WalletBalanceModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        body: json["body"] == null
            ? null
            : WalletBalanceData.fromJson(json["body"]),
      );
}

class WalletBalanceData extends Equatable {
  final int? balance;

  const WalletBalanceData({
    this.balance,
  });

  factory WalletBalanceData.fromJson(Map<String, dynamic> json) =>
      WalletBalanceData(
        balance: json["balance"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
      };

  @override
  List<Object?> get props => [
        balance,
      ];
}
