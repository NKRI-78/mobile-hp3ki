// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';

class InboxPaymentModel {
    final int? code;
    final dynamic error;
    final String? message;
    final Body? body;

    InboxPaymentModel({
        this.code,
        this.error,
        this.message,
        this.body,
    });

    factory InboxPaymentModel.fromJson(Map<String, dynamic> json) => InboxPaymentModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        body: json["body"] == null ? null : Body.fromJson(json["body"]),
    );
}

class Body extends Equatable{
    final PageDetail? pageDetail;
    final List<InboxPaymentData>? data;

    const Body({
        this.pageDetail,
        this.data,
    });

    factory Body.fromJson(Map<String, dynamic> json) => Body(
        pageDetail: json["pageDetail"] == null ? null : PageDetail.fromJson(json["pageDetail"]),
        data: json["data"] == null ? [] : List<InboxPaymentData>.from(json["data"]!.map((x) => InboxPaymentData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pageDetail": pageDetail?.toJson(),
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };

    @override
    List<Object?> get props => [
      pageDetail,
      data,
    ];
}

class InboxPaymentData extends Equatable{
    final int? id;
    final String? title;
    final String? description;
    final String? field1;
    final Field2? field2;
    final String? field3;
    final String? field4;
    final String? field5;
    final String? link;
    final String? type;
    final bool? isRead;
    final String? createdAt;

    const InboxPaymentData({
        this.id,
        this.title,
        this.description,
        this.field1,
        this.field2,
        this.field3,
        this.field4,
        this.field5,
        this.link,
        this.type,
        this.isRead,
        this.createdAt,
    });

    factory InboxPaymentData.fromJson(Map<String, dynamic> json) => InboxPaymentData(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        field1: json["field1"],
        field2: field2Values.map[json["field2"]],
        field3: json["field3"],
        field4: json["field4"],
        field5: json["field5"],
        link: json["link"],
        type: json["type"],
        isRead: json["is_read"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "field1": field1,
        "field2": field2Values.reverse[field2],
        "field3": field3,
        "field4": field4,
        "field5": field5,
        "link": link,
        "type": type,
        "is_read": isRead,
        "created_at": createdAt,
    };

    @override
    List<Object?> get props => [
      id,
      title,
      description,
      field1,
      field2,
      field3,
      field4,
      field5,
      link,
      type,
      isRead,
      createdAt,
    ];
}

enum Field2 { PAID, UNPAID }

final field2Values = EnumValues({
    "PAID": Field2.PAID,
    "UNPAID": Field2.UNPAID
});

class PageDetail {
    final int? total;
    final int? perPage;
    final int? nextPage;
    final int? prevPage;
    final int? currentPage;
    final String? nextUrl;
    final String? prevUrl;

    PageDetail({
        this.total,
        this.perPage,
        this.nextPage,
        this.prevPage,
        this.currentPage,
        this.nextUrl,
        this.prevUrl,
    });

    factory PageDetail.fromJson(Map<String, dynamic> json) => PageDetail(
        total: json["total"],
        perPage: json["per_page"],
        nextPage: json["next_page"],
        prevPage: json["prev_page"],
        currentPage: json["current_page"],
        nextUrl: json["next_url"],
        prevUrl: json["prev_url"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "per_page": perPage,
        "next_page": nextPage,
        "prev_page": prevPage,
        "current_page": currentPage,
        "next_url": nextUrl,
        "prev_url": prevUrl,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
