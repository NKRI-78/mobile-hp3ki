import 'package:equatable/equatable.dart';

class ClassificationModel {
  int? status;
  bool? error;
  String? message;
  List<ClassificationData>? data;

  ClassificationModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory ClassificationModel.fromJson(Map<String, dynamic> json) =>
      ClassificationModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<ClassificationData>.from(
            json["data"].map((x) => ClassificationData.fromJson(x))),
      );
}

class ClassificationData extends Equatable {
  final String? id;
  final String? name;

  const ClassificationData({
    this.id,
    this.name,
  });

  factory ClassificationData.fromJson(Map<String, dynamic> json) =>
      ClassificationData(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
