import 'package:equatable/equatable.dart';

class MediaModel {
  MediaModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  int? status;
  bool? error;
  String? message;
  MediaData? data;

  factory MediaModel.fromJson(Map<String, dynamic> json) => MediaModel(
        status: json["status"] ?? 0,
        error: json["error"] ?? true,
        message: json["message"] ?? "null",
        data: MediaData.fromJson(json["data"]),
      );
}

class MediaData extends Equatable {
  const MediaData({
    this.path,
    this.name,
    this.size,
    this.mimetype,
  });

  final String? path;
  final String? name;
  final String? size;
  final String? mimetype;

  factory MediaData.fromJson(Map<String, dynamic> json) => MediaData(
        path: json["path"] ??
            "https://static.vecteezy.com/system/resources/previews/015/277/489/original/can-not-load-corrupted-image-concept-illustration-flat-design-eps10-modern-graphic-element-for-landing-page-empty-state-ui-infographic-icon-vector.jpg",
        name: json["name"] ?? "null",
        size: json["size"] ?? "null",
        mimetype: json["mimetype"] ?? "null",
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "name": name,
        "size": size,
        "mimetype": mimetype,
      };

  @override
  List<Object?> get props => [
        path,
        name,
        size,
        mimetype,
      ];
}
