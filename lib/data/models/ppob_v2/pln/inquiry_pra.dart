import 'package:equatable/equatable.dart';

class InquiryPLNPrabayarModel {
    int? code;
    dynamic error;
    String? message;
    InquiryPLNPrabayarData? body;

    InquiryPLNPrabayarModel({
        this.code,
        this.error,
        this.message,
        this.body,
    });

    factory InquiryPLNPrabayarModel.fromJson(Map<String, dynamic> json) => InquiryPLNPrabayarModel(
        code: json["code"],
        error: json["error"],
        message: json["message"],
        body: InquiryPLNPrabayarData.fromJson(json["body"]),
    );
}

class InquiryPLNPrabayarData extends Equatable{
    final String? kodeProduk;
    final String? waktu;
    final String? idpel1;
    final String? idpel2;
    final String? idpel3;
    final String? namaPelanggan;
    final String? periode;
    final String? nominal;
    final String? admin;
    final String? uid;
    final String? pin;
    final String? ref1;
    final String? ref2;
    final String? ref3;
    final String? status;
    final String? ket;
    final String? saldoTerpotong;
    final String? sisaSaldo;
    final String? urlStruk;

    const InquiryPLNPrabayarData({
        this.kodeProduk,
        this.waktu,
        this.idpel1,
        this.idpel2,
        this.idpel3,
        this.namaPelanggan,
        this.periode,
        this.nominal,
        this.admin,
        this.uid,
        this.pin,
        this.ref1,
        this.ref2,
        this.ref3,
        this.status,
        this.ket,
        this.saldoTerpotong,
        this.sisaSaldo,
        this.urlStruk,
    });

    factory InquiryPLNPrabayarData.fromJson(Map<String, dynamic> json) => InquiryPLNPrabayarData(
        kodeProduk: json["kode_produk"],
        waktu: json["waktu"],
        idpel1: json["idpel1"],
        idpel2: json["idpel2"],
        idpel3: json["idpel3"],
        namaPelanggan: json["nama_pelanggan"],
        periode: json["periode"],
        nominal: json["nominal"],
        admin: json["admin"],
        uid: json["uid"],
        pin: json["pin"],
        ref1: json["ref1"],
        ref2: json["ref2"],
        ref3: json["ref3"],
        status: json["status"],
        ket: json["ket"],
        saldoTerpotong: json["saldo_terpotong"],
        sisaSaldo: json["sisa_saldo"],
        urlStruk: json["url_struk"],
    );

      Map<String, dynamic> toJson() => {
        "kode_produk": kodeProduk,
        "waktu": waktu,
        "idpel1": idpel1,
        "idpel2": idpel2,
        "idpel3": idpel3,
        "nama_pelanggan": namaPelanggan,
        "periode": periode,
        "nominal": nominal,
        "admin": admin,
        "uid": uid,
        "pin": pin,
        "ref1": ref1,
        "ref2": ref2,
        "ref3": ref3,
        "status": status,
        "ket": ket,
        "saldo_terpotong": saldoTerpotong,
        "sisa_saldo": sisaSaldo,
        "url_struk": urlStruk,
      };

  @override
  List<Object?> get props => [
    kodeProduk,
    waktu,
    idpel1,
    idpel2,
    idpel3,
    namaPelanggan,
    periode,
    nominal,
    admin,
    uid,
    pin,
    ref1,
    ref2,
    ref3,
    status,
    ket,
    saldoTerpotong,
    sisaSaldo,
    urlStruk,
  ];

}
