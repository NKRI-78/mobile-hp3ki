// To parse this JSON data, do
//
//     final packageAccount = packageAccountFromJson(jsonString);

import 'dart:convert';

PackageAccount packageAccountFromJson(String str) =>
    PackageAccount.fromJson(json.decode(str));

String packageAccountToJson(PackageAccount data) => json.encode(data.toJson());

class PackageAccount {
  int id;
  String name;
  String description;
  String data;
  int price;
  String type;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  PackageAccount({
    required this.id,
    required this.name,
    required this.description,
    required this.data,
    required this.price,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory PackageAccount.fromJson(Map<String, dynamic> json) => PackageAccount(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        data: json["data"],
        price: json["price"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "data": data,
        "price": price,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
