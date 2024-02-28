// To parse this JSON data, do
//
//     final shippingAddressModel = shippingAddressModelFromJson(jsonString);

import 'dart:convert';

ShippingAddressModel shippingAddressModelFromJson(String str) =>
    ShippingAddressModel.fromJson(json.decode(str));

String shippingAddressModelToJson(ShippingAddressModel data) =>
    json.encode(data.toJson());

class ShippingAddressModel {
  int id;
  String shippingAddressId;
  String address;
  String postalCode;
  String province;
  String city;
  String subdistrict;
  String name;
  String lat;
  String lng;
  bool defaultLocation;

  ShippingAddressModel({
    required this.id,
    required this.shippingAddressId,
    required this.address,
    required this.postalCode,
    required this.province,
    required this.city,
    required this.subdistrict,
    required this.name,
    required this.lat,
    required this.lng,
    required this.defaultLocation,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      ShippingAddressModel(
        id: json["id"],
        shippingAddressId: json["shipping_address_id"],
        address: json["address"],
        postalCode: json["postal_code"],
        province: json["province"],
        city: json["city"],
        subdistrict: json["subdistrict"],
        name: json["name"],
        lat: json["lat"],
        lng: json["lng"],
        defaultLocation: json["default_location"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shipping_address_id": shippingAddressId,
        "address": address,
        "postal_code": postalCode,
        "province": province,
        "city": city,
        "subdistrict": subdistrict,
        "name": name,
        "lat": lat,
        "lng": lng,
        "default_location": defaultLocation,
      };
}
