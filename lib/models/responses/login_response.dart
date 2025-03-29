import 'package:saving_helper/models/user_info_model.dart';

class LoginResponse {
  int? code;
  String? message;
  int? status;
  UserInfo? data;

  LoginResponse({this.code, this.message, this.status, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'],
      message: json['message'],
      status: json['status'],
      data: json['data'] != null ? UserInfo.fromJson(json['data']) : null,
    );
  }
}