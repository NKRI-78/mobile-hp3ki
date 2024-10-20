class InboxDetailModel {
  int status;
  bool error;
  String message;
  InboxDetailData data;

  InboxDetailModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory InboxDetailModel.fromJson(Map<String, dynamic> json) => InboxDetailModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: InboxDetailData.fromJson(json["data"]),
  );
}

class InboxDetailData {
  String? id;
  String? title;
  String? subject;
  String? description;
  String? link;
  InboxDeatilDataUser? user;
  bool? read;
  String? lat;
  String? lng;
  String? createdAt;
  String? updatedAt;

  InboxDetailData({
    this.id,
    this.title,
    this.subject,
    this.description,
    this.link,
    this.user,
    this.read,
    this.lat,
    this.lng,
    this.createdAt,
    this.updatedAt,
  });

  factory InboxDetailData.fromJson(Map<String, dynamic> json) => InboxDetailData(
    id: json["id"],
    title: json["title"],
    subject: json["subject"],
    description: json["description"],
    link: json["link"],
    user: InboxDeatilDataUser.fromJson(json["user"]),
    read: json["read"],
    lat: json["lat"],
    lng: json["lng"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );
}

class InboxDeatilDataUser {
  String email;

  InboxDeatilDataUser({
    required this.email,
  });

  factory InboxDeatilDataUser.fromJson(Map<String, dynamic> json) => InboxDeatilDataUser(
    email: json["email"],
  );
}
