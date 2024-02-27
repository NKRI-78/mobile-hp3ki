import 'package:equatable/equatable.dart';

class DistrictModel {
  int? status;
  bool? error;
  String? message;
  List<DistrictData>? data;

  DistrictModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<DistrictData>.from(
            json["data"].map((x) => DistrictData.fromJson(x))),
      );
}

class DistrictData extends Equatable {
  final String? id;
  final String? name;

  const DistrictData({
    this.id,
    this.name,
  });

  factory DistrictData.fromJson(Map<String, dynamic> json) => DistrictData(
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
