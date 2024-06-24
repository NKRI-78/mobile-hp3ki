import 'package:equatable/equatable.dart';

class ProvinceModel {
  int? status;
  bool? error;
  String? message;
  List<ProvinceData>? data;

  ProvinceModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<ProvinceData>.from(
            json["data"].map((x) => ProvinceData.fromJson(x))),
      );
}

class ProvinceData extends Equatable {
  final String? id;
  final String? name;

  const ProvinceData({
    this.id,
    this.name,
  });

  factory ProvinceData.fromJson(Map<String, dynamic> json) => ProvinceData(
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
