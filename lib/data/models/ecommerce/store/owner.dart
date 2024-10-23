class OwnerModel {
  int status;
  bool error;
  String message;
  OwnerData data;

  OwnerModel({
    required this.status,
    required this.error,
    required this.message,
    required this.data,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
    status: json["status"],
    error: json["error"],
    message: json["message"],
    data: OwnerData.fromJson(json["data"]),
  );
}

class OwnerData {
  bool haveStore;

  OwnerData({
    required this.haveStore,
  });

  factory OwnerData.fromJson(Map<String, dynamic> json) => OwnerData(
    haveStore: json["have_store"],
  );
}