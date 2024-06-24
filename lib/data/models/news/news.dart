import 'package:equatable/equatable.dart';

class NewsModel {
  int? status;
  bool? error;
  String? message;
  List<NewsData>? data;

  NewsModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data:
            List<NewsData>.from(json["data"].map((x) => NewsData.fromJson(x))),
      );
}

class NewsData extends Equatable {
  final String? id;
  final String? title;
  final String? desc;
  final String? image;
  final String? createdAt;

  const NewsData({
    this.id,
    this.title,
    this.desc,
    this.image,
    this.createdAt,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) => NewsData(
        id: json["id"],
        title: json["title"],
        desc: json["desc"],
        image: json["image"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "desc": desc,
        "image": image,
        "created_at": createdAt,
      };

  @override
  List<Object?> get props => [
        id,
        title,
        desc,
        image,
        createdAt,
      ];
}
