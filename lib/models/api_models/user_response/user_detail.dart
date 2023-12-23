import 'dart:convert';

import 'package:eventify/models/api_models/user_response/user_profile.dart';

class UserDetail {
  String? token;
  DateTime? expireOn;
  UserProfile? userProfile;

  UserDetail({
    this.token,
    this.expireOn,
    this.userProfile,
  });

  factory UserDetail.fromRawJson(String str) => UserDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        token: json["token"],
        expireOn:
            json["expireOn"] == null ? null : DateTime.parse(json["expireOn"]),
        userProfile: json["userProfile"] == null
            ? null
            : UserProfile.fromJson(json["userProfile"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "expireOn": expireOn?.toIso8601String(),
        "userProfile": userProfile?.toJson(),
      };
}
