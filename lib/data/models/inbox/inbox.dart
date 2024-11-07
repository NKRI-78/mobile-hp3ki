import 'package:equatable/equatable.dart';

class InboxModel {
  int? status;
  bool? error;
  String? message;
  PageDetail? pageDetail;
  List<InboxData>? data;

  InboxModel({
    this.status,
    this.error,
    this.message,
    this.pageDetail,
    this.data,
  });

  factory InboxModel.fromJson(Map<String, dynamic> json) => InboxModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        pageDetail: PageDetail.fromJson(json["pageDetail"]),
        data: List<InboxData>.from(
            json["data"].map((x) => InboxData.fromJson(x))),
      );
}

class InboxData extends Equatable {
  final String? id;
  final String? title;
  final String? subject;
  final String? description;
  final String? link;
  final User? user;
  final bool? read;
  final String? type;
  final String? paymentChannel;
  final String? paymentMethod;
  final double latitude;
  final double longitude;
  final String? createdAt;
  final String? updatedAt;

  const InboxData({
    this.id,
    this.title,
    this.subject,
    this.description,
    this.link,
    this.user,
    this.read,
    this.type,
    this.paymentChannel,
    this.paymentMethod,
    required this.latitude,
    required this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  factory InboxData.fromJson(Map<String, dynamic> json) => InboxData(
    id: json["id"],
    title: json["title"],
    subject: json["subject"],
    description: json["description"],
    link: json["link"],
    user: User.fromJson(json["user"]),
    read: json["read"],
    type: json["type"],
    paymentChannel: json["payment_channel"],
    paymentMethod: json["payment_method"],
    latitude: double.parse((json["latitude"] ?? 0).toString()),
    longitude: double.parse((json["longitude"] ?? 0).toString()),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  @override
  List<Object?> get props => [
    id,
    title,
    subject,
    description,
    link,
    user,
    read,
    createdAt,
    updatedAt,
    latitude,
    longitude,
  ];
}

class User extends Equatable {
  final String? email;

  const User({
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  List<Object?> get props => [
        email,
      ];
}

class PageDetail {
  int? badges;
  int? total;
  int? perPage;
  int? nextPage;
  int? prevPage;
  int? currentPage;
  String? nextUrl;
  String? prevUrl;

  PageDetail({
    this.badges,
    this.total,
    this.perPage,
    this.nextPage,
    this.prevPage,
    this.currentPage,
    this.nextUrl,
    this.prevUrl,
  });

  factory PageDetail.fromJson(Map<String, dynamic> json) => PageDetail(
        badges: json["badges"],
        total: json["total"],
        perPage: json["per_page"],
        nextPage: json["next_page"],
        prevPage: json["prev_page"],
        currentPage: json["current_page"],
        nextUrl: json["next_url"],
        prevUrl: json["prev_url"],
      );
}
