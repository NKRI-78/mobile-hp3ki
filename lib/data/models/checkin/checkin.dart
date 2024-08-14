import 'package:equatable/equatable.dart';

class CheckInModel {
  int? status;
  bool? error;
  String? message;
  List<CheckInData>? data;

  CheckInModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) => CheckInModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: List<CheckInData>.from(json["data"].map((x) => CheckInData.fromJson(x))),
  );
}

class CheckInData extends Equatable {
  final String? id;
  final String? title;
  final String? desc;
  final String? location;
  final String? lat; 
  final String? lng;
  final String? start;
  final String? end;
  final bool? isPass;
  final Joined? joined;
  final bool? join;
  final String? checkinDate;
  final User? user;

  const CheckInData({
    this.id,
    this.title,
    this.desc,
    this.location,
    this.lat,
    this.lng,
    this.start,
    this.end,
    this.isPass,
    this.joined,
    this.join,
    this.checkinDate,
    this.user,
  });

  factory CheckInData.fromJson(Map<String, dynamic> json) => CheckInData(
    id: json["id"],
    title: json["title"],
    desc: json["desc"],
    location: json["location"],
    lat: json["lat"],
    lng: json["lng"],
    start: json["start"],
    end: json["end"],
    isPass: json["is_pass"],
    joined: Joined.fromJson(json["joined"]),
    join: json["join"],
    checkinDate: json["checkin_date"],
    user: User.fromJson(json["user"]),
  );

  @override
  List<Object?> get props => [
    id,
    title,
    desc,
    location,
    lat,
    lng,
    start,
    end,
    isPass,
    joined,
    join,
    checkinDate,
    user,
  ];
}

class Joined extends Equatable {
  final List<User>? user;

  const Joined({
    this.user,
  });

  factory Joined.fromJson(Map<String, dynamic> json) => Joined(
    user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
  );

  @override
  List<Object?> get props => [
    user,
  ];
}

class User extends Equatable {
  final String? id;
  final String? name;
  final String? avatar;

  const User({
    this.id,
    this.name,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
  );

  @override
  List<Object?> get props => [
    id,
    name,
    avatar,
  ];
}
