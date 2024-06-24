import 'package:equatable/equatable.dart';

class FeedMedia extends Equatable {
  const FeedMedia({
    this.path,
  });

  final String? path;

  factory FeedMedia.fromJson(Map<String, dynamic> json) => FeedMedia(
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
      };

  @override
  List<Object?> get props => [
        path,
      ];
}
