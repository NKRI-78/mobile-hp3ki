import 'package:equatable/equatable.dart';

class BusinessModel {
  int? status;
  bool? error;
  String? message;
  List<BusinessData>? data;

  BusinessModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) => BusinessModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<BusinessData>.from(
            json["data"].map((x) => BusinessData.fromJson(x))),
      );
}

class BusinessData extends Equatable {
  final String? id;
  final String? name;

  const BusinessData({
    this.id,
    this.name,
  });

  factory BusinessData.fromJson(Map<String, dynamic> json) => BusinessData(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
