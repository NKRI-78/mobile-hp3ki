// To parse this JSON data, do
//
//     final jneTrackingModel = jneTrackingModelFromJson(jsonString);

import 'dart:convert';

JneTrackingModel jneTrackingModelFromJson(String str) =>
    JneTrackingModel.fromJson(json.decode(str));

String jneTrackingModelToJson(JneTrackingModel data) =>
    json.encode(data.toJson());

class JneTrackingModel {
  Cnote cnote;
  List<Detail> detail;
  List<History> history;

  JneTrackingModel({
    required this.cnote,
    required this.detail,
    required this.history,
  });

  factory JneTrackingModel.fromJson(Map<String, dynamic> json) =>
      JneTrackingModel(
        cnote: Cnote.fromJson(json["cnote"]),
        detail:
            List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
        history:
            List<History>.from(json["history"].map((x) => History.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cnote": cnote.toJson(),
        "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
        "history": List<dynamic>.from(history.map((x) => x.toJson())),
      };
}

class Cnote {
  String cnoteNo;
  String referenceNumber;
  String cnoteOrigin;
  String cnoteDestination;
  String cnoteServicesCode;
  String servicetype;
  String cnoteCustNo;
  DateTime cnoteDate;
  dynamic cnotePodReceiver;
  String cnoteReceiverName;
  String cityName;
  dynamic cnotePodDate;
  String podStatus;
  String lastStatus;
  String custType;
  String cnoteAmount;
  String cnoteWeight;
  dynamic podCode;
  dynamic keterangan;
  String cnoteGoodsDescr;
  String freightCharge;
  String shippingcost;
  String insuranceamount;
  String priceperkg;
  dynamic signature;
  dynamic photo;
  dynamic long;
  dynamic lat;
  String estimateDelivery;

  Cnote({
    required this.cnoteNo,
    required this.referenceNumber,
    required this.cnoteOrigin,
    required this.cnoteDestination,
    required this.cnoteServicesCode,
    required this.servicetype,
    required this.cnoteCustNo,
    required this.cnoteDate,
    required this.cnotePodReceiver,
    required this.cnoteReceiverName,
    required this.cityName,
    required this.cnotePodDate,
    required this.podStatus,
    required this.lastStatus,
    required this.custType,
    required this.cnoteAmount,
    required this.cnoteWeight,
    required this.podCode,
    required this.keterangan,
    required this.cnoteGoodsDescr,
    required this.freightCharge,
    required this.shippingcost,
    required this.insuranceamount,
    required this.priceperkg,
    required this.signature,
    required this.photo,
    required this.long,
    required this.lat,
    required this.estimateDelivery,
  });

  factory Cnote.fromJson(Map<String, dynamic> json) => Cnote(
        cnoteNo: json["cnote_no"],
        referenceNumber: json["reference_number"],
        cnoteOrigin: json["cnote_origin"],
        cnoteDestination: json["cnote_destination"],
        cnoteServicesCode: json["cnote_services_code"],
        servicetype: json["servicetype"],
        cnoteCustNo: json["cnote_cust_no"],
        cnoteDate: DateTime.parse(json["cnote_date"]),
        cnotePodReceiver: json["cnote_pod_receiver"],
        cnoteReceiverName: json["cnote_receiver_name"],
        cityName: json["city_name"],
        cnotePodDate: json["cnote_pod_date"],
        podStatus: json["pod_status"],
        lastStatus: json["last_status"],
        custType: json["cust_type"],
        cnoteAmount: json["cnote_amount"],
        cnoteWeight: json["cnote_weight"],
        podCode: json["pod_code"],
        keterangan: json["keterangan"],
        cnoteGoodsDescr: json["cnote_goods_descr"],
        freightCharge: json["freight_charge"],
        shippingcost: json["shippingcost"],
        insuranceamount: json["insuranceamount"],
        priceperkg: json["priceperkg"],
        signature: json["signature"],
        photo: json["photo"],
        long: json["long"],
        lat: json["lat"],
        estimateDelivery: json["estimate_delivery"],
      );

  Map<String, dynamic> toJson() => {
        "cnote_no": cnoteNo,
        "reference_number": referenceNumber,
        "cnote_origin": cnoteOrigin,
        "cnote_destination": cnoteDestination,
        "cnote_services_code": cnoteServicesCode,
        "servicetype": servicetype,
        "cnote_cust_no": cnoteCustNo,
        "cnote_date": cnoteDate.toIso8601String(),
        "cnote_pod_receiver": cnotePodReceiver,
        "cnote_receiver_name": cnoteReceiverName,
        "city_name": cityName,
        "cnote_pod_date": cnotePodDate,
        "pod_status": podStatus,
        "last_status": lastStatus,
        "cust_type": custType,
        "cnote_amount": cnoteAmount,
        "cnote_weight": cnoteWeight,
        "pod_code": podCode,
        "keterangan": keterangan,
        "cnote_goods_descr": cnoteGoodsDescr,
        "freight_charge": freightCharge,
        "shippingcost": shippingcost,
        "insuranceamount": insuranceamount,
        "priceperkg": priceperkg,
        "signature": signature,
        "photo": photo,
        "long": long,
        "lat": lat,
        "estimate_delivery": estimateDelivery,
      };
}

class Detail {
  String cnoteNo;
  DateTime cnoteDate;
  String cnoteWeight;
  String cnoteOrigin;
  String cnoteShipperName;
  String cnoteShipperAddr1;
  String cnoteShipperAddr2;
  String cnoteShipperAddr3;
  String cnoteShipperCity;
  String cnoteReceiverName;
  String cnoteReceiverAddr1;
  String cnoteReceiverAddr2;
  String cnoteReceiverAddr3;
  String cnoteReceiverCity;

  Detail({
    required this.cnoteNo,
    required this.cnoteDate,
    required this.cnoteWeight,
    required this.cnoteOrigin,
    required this.cnoteShipperName,
    required this.cnoteShipperAddr1,
    required this.cnoteShipperAddr2,
    required this.cnoteShipperAddr3,
    required this.cnoteShipperCity,
    required this.cnoteReceiverName,
    required this.cnoteReceiverAddr1,
    required this.cnoteReceiverAddr2,
    required this.cnoteReceiverAddr3,
    required this.cnoteReceiverCity,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        cnoteNo: json["cnote_no"],
        cnoteDate: DateTime.parse(json["cnote_date"]),
        cnoteWeight: json["cnote_weight"],
        cnoteOrigin: json["cnote_origin"],
        cnoteShipperName: json["cnote_shipper_name"],
        cnoteShipperAddr1: json["cnote_shipper_addr1"],
        cnoteShipperAddr2: json["cnote_shipper_addr2"],
        cnoteShipperAddr3: json["cnote_shipper_addr3"],
        cnoteShipperCity: json["cnote_shipper_city"],
        cnoteReceiverName: json["cnote_receiver_name"],
        cnoteReceiverAddr1: json["cnote_receiver_addr1"],
        cnoteReceiverAddr2: json["cnote_receiver_addr2"],
        cnoteReceiverAddr3: json["cnote_receiver_addr3"],
        cnoteReceiverCity: json["cnote_receiver_city"],
      );

  Map<String, dynamic> toJson() => {
        "cnote_no": cnoteNo,
        "cnote_date": cnoteDate.toIso8601String(),
        "cnote_weight": cnoteWeight,
        "cnote_origin": cnoteOrigin,
        "cnote_shipper_name": cnoteShipperName,
        "cnote_shipper_addr1": cnoteShipperAddr1,
        "cnote_shipper_addr2": cnoteShipperAddr2,
        "cnote_shipper_addr3": cnoteShipperAddr3,
        "cnote_shipper_city": cnoteShipperCity,
        "cnote_receiver_name": cnoteReceiverName,
        "cnote_receiver_addr1": cnoteReceiverAddr1,
        "cnote_receiver_addr2": cnoteReceiverAddr2,
        "cnote_receiver_addr3": cnoteReceiverAddr3,
        "cnote_receiver_city": cnoteReceiverCity,
      };
}

class History {
  String date;
  String desc;
  String code;
  dynamic photo1;
  dynamic photo2;
  dynamic photo3;
  dynamic photo4;
  dynamic photo5;

  History({
    required this.date,
    required this.desc,
    required this.code,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.photo4,
    required this.photo5,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
        date: json["date"],
        desc: json["desc"],
        code: json["code"],
        photo1: json["photo1"],
        photo2: json["photo2"],
        photo3: json["photo3"],
        photo4: json["photo4"],
        photo5: json["photo5"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "desc": desc,
        "code": code,
        "photo1": photo1,
        "photo2": photo2,
        "photo3": photo3,
        "photo4": photo4,
        "photo5": photo5,
      };
}
