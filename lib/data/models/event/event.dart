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
    this.joined,
    this.start,
    this.end,
  });

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
        id: json["id"],
        picture: json["picture"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
        location: json["location"],
        paid: json["paid"],
        joined: json["joined"],
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "picture": picture,
        "title": title,
        "description": description,
        "date": date,
        "location": location,
        "paid": paid,
        "joined": joined,
        "start": start,
        "end": end,
      };

  @override
  List<Object?> get props => [
        id,
        picture,
        title,
        description,
        date,
        location,
        paid,
        joined,
        start,
        end,
      ];
}
