// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final shopModel = shopModelFromJson(jsonString);

import 'dart:convert';

ShopModel shopModelFromJson(String str) => ShopModel.fromJson(json.decode(str));

String shopModelToJson(ShopModel data) => json.encode(data.toJson());

class ShopModel {
  int total;
  int perPage;
  int nextPage;
  int prevPage;
  int currentPage;
  String nextUrl;
  String prevUrl;
  List<Datum> data;

  ShopModel({
    required this.total,
    required this.perPage,
    required this.nextPage,
    required this.prevPage,
    required this.currentPage,
    required this.nextUrl,
    required this.prevUrl,
    required this.data,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        total: json["total"],
        perPage: json["per_page"],
        nextPage: json["next_page"],
        prevPage: json["prev_page"],
        currentPage: json["current_page"],
        nextUrl: json["next_url"],
        prevUrl: json["prev_url"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "per_page": perPage,
        "next_page": nextPage,
        "prev_page": prevPage,
        "current_page": currentPage,
        "next_url": nextUrl,
        "prev_url": prevUrl,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };

  ShopModel copyWith({
    int? total,
    int? perPage,
    int? nextPage,
    int? prevPage,
    int? currentPage,
    String? nextUrl,
    String? prevUrl,
    List<Datum>? data,
  }) {
    return ShopModel(
      total: total ?? this.total,
      perPage: perPage ?? this.perPage,
      nextPage: nextPage ?? this.nextPage,
      prevPage: prevPage ?? this.prevPage,
      currentPage: currentPage ?? this.currentPage,
      nextUrl: nextUrl ?? this.nextUrl,
      prevUrl: prevUrl ?? this.prevUrl,
      data: data ?? this.data,
    );
  }
}

class Datum {
  String id;
  String name;
  int price;
  int weight;
  String picture;
  String description;
  int stock;
  int minOrder;
  String condition;
  Category category;
  Review review;
  Store store;

  Datum({
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
    required this.picture,
    required this.description,
    required this.stock,
    required this.minOrder,
    required this.condition,
    required this.category,
    required this.review,
    required this.store,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        weight: json["weight"],
        picture: json["picture"],
        description: json["description"],
        stock: json["stock"],
        minOrder: json["min_order"],
        condition: json["condition"],
        category: Category.fromJson(json["category"]),
        review: Review.fromJson(json["review"]),
        store: Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "weight": weight,
        "picture": picture,
        "description": description,
        "stock": stock,
        "min_order": minOrder,
        "condition": condition,
        "category": category.toJson(),
        "review": review.toJson(),
        "store": store.toJson(),
      };
}

class Category {
  String id;
  String name;
  String type;

  Category({
    required this.id,
    required this.name,
    required this.type,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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

class Review {
  String id;
  String rating;
  int total;

  Review({
    required this.id,
    required this.rating,
    required this.total,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        rating: json["rating"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rating": rating,
        "total": total,
      };
}

class Store {
  String id;
  String name;
  String picture;
  String description;
  Address address;

  Store({
    required this.id,
    required this.name,
    required this.picture,
    required this.description,
    required this.address,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["id"],
        name: json["name"],
        picture: json["picture"],
        description: json["description"],
        address: Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "picture": picture,
        "description": description,
        "address": address.toJson(),
      };
}

class Address {
  String province;
  String city;
  String subdistrict;

  Address({
    required this.province,
    required this.city,
    required this.subdistrict,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        province: json["province"],
        city: json["city"],
        subdistrict: json["subdistrict"],
      );

  Map<String, dynamic> toJson() => {
        "province": province,
        "city": city,
        "subdistrict": subdistrict,
      };
}
