import 'package:equatable/equatable.dart';

class SubdistrictModel {
  int? status;
  bool? error;
  String? message;
  List<SubdistrictData>? data;

  SubdistrictModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory SubdistrictModel.fromJson(Map<String, dynamic> json) =>
      SubdistrictModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<SubdistrictData>.from(
            json["data"].map((x) => SubdistrictData.fromJson(x))),
      );
}

class SubdistrictData extends Equatable {
  final String? id;
  final String? name;

  const SubdistrictData({
    this.id,
    this.name,
  });

  factory SubdistrictData.fromJson(Map<String, dynamic> json) =>
      SubdistrictData(
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
