// To parse this JSON data, do
//
//     final myStoreModel = myStoreModelFromJson(jsonString);

import 'dart:convert';

MyStoreModel myStoreModelFromJson(String str) =>
    MyStoreModel.fromJson(json.decode(str));

String myStoreModelToJson(MyStoreModel data) => json.encode(data.toJson());

class MyStoreModel {
  String storeId;
  String owner;
  String name;
  String description;
  String picture;
  String province;
  String city;
  String district;
  String subdistrict;
  String postalCode;
  String address;
  String email;
  String phone;
  String lat;
  String lng;
  int open;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  MyStoreModel({
    required this.storeId,
    required this.owner,
    required this.name,
    required this.description,
    required this.picture,
    required this.province,
    required this.city,
    required this.district,
    required this.subdistrict,
    required this.postalCode,
    required this.address,
    required this.email,
    required this.phone,
    required this.lat,
    required this.lng,
    required this.open,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MyStoreModel.fromJson(Map<String, dynamic> json) => MyStoreModel(
        storeId: json["store_id"],
        owner: json["owner"],
        name: json["name"],
        description: json["description"],
        picture: json["picture"],
        province: json["province"],
        city: json["city"],
        district: json["district"],
        subdistrict: json["subdistrict"],
        postalCode: json["postal_code"],
        address: json["address"],
        email: json["email"],
        phone: json["phone"],
        lat: json["lat"],
        lng: json["lng"],
        open: json["open"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "owner": owner,
        "name": name,
        "description": description,
        "picture": picture,
        "province": province,
        "city": city,
        "district": district,
        "subdistrict": subdistrict,
        "postal_code": postalCode,
        "address": address,
        "email": email,
        "phone": phone,
        "lat": lat,
        "lng": lng,
        "open": open,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
