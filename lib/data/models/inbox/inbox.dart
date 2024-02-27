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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subject": subject,
        "description": description,
        "link": link,
        "user": user?.toJson(),
        "read": read,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

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
