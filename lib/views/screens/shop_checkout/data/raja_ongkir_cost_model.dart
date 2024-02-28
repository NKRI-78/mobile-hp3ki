// To parse this JSON data, do
//
//     final rajaOngkirCostModel = rajaOngkirCostModelFromJson(jsonString);

import 'dart:convert';

RajaOngkirCostModel rajaOngkirCostModelFromJson(String str) =>
    RajaOngkirCostModel.fromJson(json.decode(str));

String rajaOngkirCostModelToJson(RajaOngkirCostModel data) =>
    json.encode(data.toJson());

class RajaOngkirCostModel {
  Destination origin;
  Destination destination;
  List<Datum> data;

  RajaOngkirCostModel({
    required this.origin,
    required this.destination,
    required this.data,
  });

  factory RajaOngkirCostModel.fromJson(Map<String, dynamic> json) =>
      RajaOngkirCostModel(
        origin: Destination.fromJson(json["origin"]),
        destination: Destination.fromJson(json["destination"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "origin": origin.toJson(),
        "destination": destination.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String code;
  String name;
  List<RoService> costs;

  Datum({
    required this.code,
    required this.name,
    required this.costs,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        code: json["code"],
        name: json["name"],
        costs: List<RoService>.from(
            json["costs"].map((x) => RoService.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "costs": List<dynamic>.from(costs.map((x) => x.toJson())),
      };
}

class RoService {
  String service;
  String description;
  List<CostCost> cost;

  RoService({
    required this.service,
    required this.description,
    required this.cost,
  });

  factory RoService.fromJson(Map<String, dynamic> json) => RoService(
        service: json["service"],
        description: json["description"],
        cost:
            List<CostCost>.from(json["cost"].map((x) => CostCost.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service": service,
        "description": description,
        "cost": List<dynamic>.from(cost.map((x) => x.toJson())),
      };
}

class CostCost {
  int value;
  String etd;
  String note;

  CostCost({
    required this.value,
    required this.etd,
    required this.note,
  });

  factory CostCost.fromJson(Map<String, dynamic> json) => CostCost(
        value: json["value"],
        etd: json["etd"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "etd": etd,
        "note": note,
      };
}

class Destination {
  String subdistrictId;
  String provinceId;
  String province;
  String cityId;
  String city;
  String type;
  String subdistrictName;

  Destination({
    required this.subdistrictId,
    required this.provinceId,
    required this.province,
    required this.cityId,
    required this.city,
    required this.type,
    required this.subdistrictName,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
        subdistrictId: json["subdistrict_id"],
        provinceId: json["province_id"],
        province: json["province"],
        cityId: json["city_id"],
        city: json["city"],
        type: json["type"],
        subdistrictName: json["subdistrict_name"],
      );

  Map<String, dynamic> toJson() => {
        "subdistrict_id": subdistrictId,
        "province_id": provinceId,
        "province": province,
        "city_id": cityId,
        "city": city,
        "type": type,
        "subdistrict_name": subdistrictName,
      };
}
