// To parse this JSON data, do
//
//     final genericResponse = genericResponseFromJson(jsonString);

import 'dart:convert';

GenericResponse genericResponseFromJson(String str) =>
    GenericResponse.fromJson(json.decode(str));

String genericResponseToJson(GenericResponse data) =>
    json.encode(data.toJson());

class GenericResponse {
  final bool? success;
  final String? message;

  GenericResponse({
    this.success,
    this.message,
  });

  factory GenericResponse.fromJson(Map<String, dynamic> json) =>
      GenericResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
