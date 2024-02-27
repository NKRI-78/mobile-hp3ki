import 'package:equatable/equatable.dart';

class OrganizationModel {
  int? status;
  bool? error;
  String? message;
  List<OrganizationData>? data;

  OrganizationModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      OrganizationModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<OrganizationData>.from(
            json["data"].map((x) => OrganizationData.fromJson(x))),
      );
}

class OrganizationData extends Equatable {
  final String? id;
  final String? name;
  final String? createdAt;

  const OrganizationData({
    this.id,
    this.name,
    this.createdAt,
  });

  factory OrganizationData.fromJson(Map<String, dynamic> json) =>
      OrganizationData(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        createdAt,
      ];
}
