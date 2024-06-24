import 'package:equatable/equatable.dart';

class SingleNewsModel {
  int? status;
  bool? error;
  String? message;
  SingleNewsData? data;

  SingleNewsModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory SingleNewsModel.fromJson(Map<String, dynamic> json) =>
      SingleNewsModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: SingleNewsData.fromJson(json["data"]),
      );
}

class SingleNewsData extends Equatable {
  final String? uid;
  final String? title;
  final String? desc;
  final String? image;
  final String? createdAt;

  const SingleNewsData({
    this.uid,
    this.title,
    this.desc,
    this.image,
    this.createdAt,
  });

  factory SingleNewsData.fromJson(Map<String, dynamic> json) => SingleNewsData(
        uid: json["uid"],
        title: json["title"],
        desc: json["desc"],
        image: json["image"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "title": title,
        "desc": desc,
        "image": image,
        "created_at": createdAt,
      };

  @override
  List<Object?> get props => [
        uid,
        title,
        desc,
        image,
        createdAt,
      ];
}
