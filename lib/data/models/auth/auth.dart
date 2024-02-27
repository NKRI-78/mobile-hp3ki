import 'package:equatable/equatable.dart';

class AuthModel {
  int? status;
  bool? error;
  String? message;
  AuthData? data;

  AuthModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        status: json["status"],
        error: json["error"],
        message: json["message"],
        data: AuthData.fromJson(json["data"]),
      );
}

class AuthData {
  String? token;
  String? refreshToken;
  AuthUser? user;

  AuthData({
    this.token,
    this.refreshToken,
    this.user,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        token: json["token"],
        refreshToken: json["refresh_token"],
        user: AuthUser.fromJson(json["user"]),
      );
}

class AuthUser extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final bool? emailActivated;
  final String? phone;
  final bool? phoneActivated;
  final String? role;

  const AuthUser({
    this.id,
    this.name,
    this.email,
    this.emailActivated,
    this.phone,
    this.phoneActivated,
    this.role,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailActivated: json["email_activated"],
        phone: json["phone"],
        phoneActivated: json["phone_activated"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "email_activated": emailActivated,
        "name": name,
        "phone": phone,
        "phone_activated": phoneActivated,
        "role": role,
      };

  @override
  List<Object?> get props => [
        id,
        phone,
        email,
        emailActivated,
        phone,
        phoneActivated,
        role,
      ];
}
