// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id;
  String name;
  String picture;
  int price;
  int stock;
  int status;

  ProductModel({
    required this.id,
    required this.name,
    required this.picture,
    required this.price,
    required this.stock,
    required this.status,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"],
        stock: json["stock"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "picture": picture,
        "price": price,
        "stock": stock,
        "status": status,
      };
}
