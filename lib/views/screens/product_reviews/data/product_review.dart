// To parse this JSON data, do
//
//     final productReviewModel = productReviewModelFromJson(jsonString);

import 'dart:convert';

ProductReviewModel productReviewModelFromJson(String str) =>
    ProductReviewModel.fromJson(json.decode(str));

String productReviewModelToJson(ProductReviewModel data) =>
    json.encode(data.toJson());

class ProductReviewModel {
  String avatar;
  List<String> reviewPictures;
  String name;
  String caption;
  String rating;
  DateTime createdAt;

  ProductReviewModel({
    required this.avatar,
    required this.reviewPictures,
    required this.name,
    required this.caption,
    required this.rating,
    required this.createdAt,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) =>
      ProductReviewModel(
        avatar: json["avatar"],
        reviewPictures:
            List<String>.from(json["review_pictures"].map((x) => x)),
        name: json["name"],
        caption: json["caption"],
        rating: json["rating"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "review_pictures": List<dynamic>.from(reviewPictures.map((x) => x)),
        "name": name,
        "caption": caption,
        "rating": rating,
        "created_at": createdAt.toIso8601String(),
      };
}
