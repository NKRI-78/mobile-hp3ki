import 'package:equatable/equatable.dart';

class CityModel {
  int? status;
  bool? error;
  String? message;
  List<CityData>? data;

  CityModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data:
            List<CityData>.from(json["data"].map((x) => CityData.fromJson(x))),
      );
}

class CityData extends Equatable {
  final String? id;
  final String? name;

  const CityData({
    this.id,
    this.name,
  });

  factory CityData.fromJson(Map<String, dynamic> json) => CityData(
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
