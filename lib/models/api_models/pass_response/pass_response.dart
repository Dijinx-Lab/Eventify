// To parse this JSON data, do
//
//     final passResponse = passResponseFromJson(jsonString);

import 'dart:convert';

PassResponse passResponseFromJson(String str) =>
    PassResponse.fromJson(json.decode(str));

String passResponseToJson(PassResponse data) => json.encode(data.toJson());

class PassResponse {
  final bool? success;
  final Data? data;
  final String? message;

  PassResponse({
    this.success,
    this.data,
    this.message,
  });

  factory PassResponse.fromJson(Map<String, dynamic> json) => PassResponse(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  final List<String>? passIds;

  Data({
    this.passIds,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        passIds: json["pass_ids"] == null
            ? []
            : List<String>.from(json["pass_ids"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "pass_ids":
            passIds == null ? [] : List<dynamic>.from(passIds!.map((x) => x)),
      };
}
