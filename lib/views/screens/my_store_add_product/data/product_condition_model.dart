// To parse this JSON data, do
//
//     final productConditionModel = productConditionModelFromJson(jsonString);

import 'dart:convert';

ProductConditionModel productConditionModelFromJson(String str) =>
    ProductConditionModel.fromJson(json.decode(str));

String productConditionModelToJson(ProductConditionModel data) =>
    json.encode(data.toJson());

class ProductConditionModel {
  String id;
  String name;

  ProductConditionModel({
    required this.id,
    required this.name,
  });

  factory ProductConditionModel.fromJson(Map<String, dynamic> json) =>
      ProductConditionModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
