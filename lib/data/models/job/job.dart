import 'package:equatable/equatable.dart';

class JobModel {
  int? status;
  bool? error;
  String? message;
  List<JobData>? data;

  JobModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: List<JobData>.from(json["data"].map((x) => JobData.fromJson(x))),
      );
}

class JobData extends Equatable {
  final String? id;
  final String? name;

  const JobData({
    this.id,
    this.name,
  });

  factory JobData.fromJson(Map<String, dynamic> json) => JobData(
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
