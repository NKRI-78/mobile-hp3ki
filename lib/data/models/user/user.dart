import 'package:equatable/equatable.dart';

class UserModel {
  int? status;
  bool? error;
  String? message;
  UserData? data;

  UserModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: UserData.fromJson(json["data"]),
      );
}

class UserData extends Equatable {
  final String? id;
  final String? avatar;
  final String? fullname;
  final String? email;
  final String? phone;
  final String? role;
  final String? picKtp;
  final String? addressKtp;
  final String? noKtp;
  final String? noMember;
  final String? organization;
  final String? organizationPath;
  final String? organizationBahasa;
  final String? organizationEnglish;
  final String? job;
  final String? jobId;
  final String? memberType;
  final int? remainingDays;
  final bool? fulfilledUserData;
  final String? storeId;
  final String? noReferral;

  const UserData({
    this.id,
    this.avatar,
    this.fullname,
    this.email,
    this.phone,
    this.role,
    this.picKtp,
    this.addressKtp,
    this.noKtp,
    this.noMember,
    this.job,
    this.jobId,
    this.organization,
    this.organizationPath,
    this.organizationBahasa,
    this.organizationEnglish,
    this.memberType,
    this.remainingDays,
    this.fulfilledUserData,
    this.storeId,
    this.noReferral,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
      id: json["id"],
      avatar: json["avatar"],
      fullname: json["fullname"],
      email: json["email"],
      phone: json["phone"],
      role: json["role"],
      picKtp: json["pic_ktp"],
      addressKtp: json["address_ktp"],
      noKtp: json["no_ktp"],
      noMember: json["no_member"],
      job: json["job"],
      jobId: json["job_id"],
      organization: json["organization"],
      organizationPath: json["organization_path"],
      organizationBahasa: json["organization_bahasa_name"],
      organizationEnglish: json["organization_english_name"],
      memberType: json["member_type"],
      remainingDays: json["remaining_days"],
      fulfilledUserData: json["fulfilledData"],
      storeId: json['store_id'],
      noReferral: json['no_referral']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
        "fullname": fullname,
        "email": email,
        "phone": phone,
        "role": role,
        "pic_ktp": picKtp,
        "address_ktp": addressKtp,
        "no_ktp": noKtp,
        "no_member": noMember,
        "job_id": jobId,
        "job": job,
        "organization": organization,
        "organization_path": organizationPath,
        "organization_bahasa_name": organizationBahasa,
        "organization_english_name": organizationEnglish,
        "member_type": memberType,
        "remaining_days": remainingDays,
        "fulfilledData": fulfilledUserData,
        "store_id": storeId,
        "no_referral": noReferral
      };

  @override
  List<Object?> get props => [
        id,
        avatar,
        fullname,
        email,
        phone,
        role,
        picKtp,
        addressKtp,
        noKtp,
        noMember,
        job,
        jobId,
        organization,
        organizationPath,
        organizationBahasa,
        organizationEnglish,
        memberType,
        remainingDays,
        fulfilledUserData,
        storeId,
        noReferral,
      ];
}
