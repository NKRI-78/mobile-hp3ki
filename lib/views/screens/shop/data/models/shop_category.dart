import 'dart:convert';

ShopCategoryModel shopCategoryModelFromJson(String str) =>
    ShopCategoryModel.fromJson(json.decode(str));

String shopCategoryModelToJson(ShopCategoryModel data) =>
    json.encode(data.toJson());

class ShopCategoryModel {
  String id;
  String name;
  String type;

  ShopCategoryModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory ShopCategoryModel.fromJson(Map<String, dynamic> json) =>
      ShopCategoryModel(
        id: json["id"],
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
      };
}
