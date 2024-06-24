import 'package:equatable/equatable.dart';

class MemberNearModel {
  int? status;
  bool? error;
  String? message;
  PageDetail? pageDetail;
  List<MemberNearData>? data;

  MemberNearModel({
    this.status,
    this.error,
    this.message,
    this.pageDetail,
    this.data,
  });

  factory MemberNearModel.fromJson(Map<String, dynamic> json) =>
      MemberNearModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        pageDetail: PageDetail.fromJson(json["pageDetail"]),
        data: List<MemberNearData>.from(
            json["data"].map((x) => MemberNearData.fromJson(x))),
      );
}

class MemberNearData extends Equatable {
  final User? user;
  final String? distance;
  final String? lat;
  final String? lng;

  const MemberNearData({
    this.user,
    this.distance,
    this.lat,
    this.lng,
  });

  factory MemberNearData.fromJson(Map<String, dynamic> json) => MemberNearData(
        user: User.fromJson(json["user"]),
        distance: json["distance"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "distance": distance,
        "lat": lat,
        "lng": lng,
      };

  @override
  List<Object?> get props => [
        user,
        distance,
        lat,
        lng,
      ];
}

class User extends Equatable {
  final String? avatar;
  final String? name;
  final String? email;
  final String? phone;

  const User({
    this.avatar,
    this.name,
    this.email,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        avatar: json["avatar"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "name": name,
        "email": email,
        "phone": phone,
      };

  @override
  List<Object?> get props => [
        avatar,
        name,
        email,
        phone,
      ];
}

class PageDetail {
  int? total;
  int? perPage;
  int? nextPage;
  int? prevPage;
  int? currentPage;
  String? nextUrl;
  String? prevUrl;

  PageDetail({
    this.total,
    this.perPage,
    this.nextPage,
    this.prevPage,
    this.currentPage,
    this.nextUrl,
    this.prevUrl,
  });

  factory PageDetail.fromJson(Map<String, dynamic> json) => PageDetail(
        total: json["total"],
        perPage: json["per_page"],
        nextPage: json["next_page"],
        prevPage: json["prev_page"],
        currentPage: json["current_page"],
        nextUrl: json["next_url"],
        prevUrl: json["prev_url"],
      );
}
