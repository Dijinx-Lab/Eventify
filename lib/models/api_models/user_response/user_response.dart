import 'dart:convert';

import 'package:eventify/models/api_models/user_response/user_detail.dart';

class UserResponse {
  bool? isSuccess;
  String? message;
  UserDetail? data;

  UserResponse({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory UserResponse.fromRawJson(String str) =>
      UserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: json["data"] == null ? null : UserDetail.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": data?.toJson(),
      };
}
