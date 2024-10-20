import 'package:equatable/equatable.dart';

class EventModel {
  int? status;
  bool? error;
  String? message;
  List<EventData>? data;

  EventModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<EventData>.from(
        json["data"].map((x) => EventData.fromJson(x))),
      );
}
class EventData extends Equatable {
  final String? id;
  final String? picture;
  final String? title;
  final String? description;
  final String? date;
  final String? location;
  final bool? paid;
  final bool? isPass;
  final List<dynamic>? users; // Specify the type if possible
  final bool? joined;
  final String? start;
  final String? end;

  const EventData({
    this.id,
    this.picture,
    this.title,
    this.description,
    this.date,
    this.location,
    this.paid,
    this.isPass,
    this.users,
    this.joined,
    this.start,
    this.end,
  });

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    id: json["id"] as String?,
    picture: json["picture"] as String?,
    title: json["title"] as String?,
    description: json["description"] as String?,
    date: json["date"] as String?,
    location: json["location"] as String?,
    paid: json["paid"] as bool?,
    isPass: json["is_passed"] as bool?,
    users: json["users"] != null ? List<dynamic>.from(json["users"]) : null, // Adjust type here
    joined: json["joined"] as bool?,
    start: json["start"] as String?,
    end: json["end"] as String?,
  );

  @override
  List<Object?> get props => [
    id,
    picture,
    title,
    description,
    date,
    location,
    paid,
    isPass,
    users,
    joined,
    start,
    end,
  ];
}