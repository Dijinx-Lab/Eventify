import 'dart:convert';

import 'package:eventify/models/api_models/sale_response/sale.dart';

class SaleResponse {
  final bool? success;
  final Data? data;
  final String? message;

  SaleResponse({
    this.success,
    this.data,
    this.message,
  });

  factory SaleResponse.fromRawJson(String str) =>
      SaleResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SaleResponse.fromJson(Map<String, dynamic> json) => SaleResponse(
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
  final Sale? sale;

  Data({
    this.sale,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sale: json["sale"] == null ? null : Sale.fromJson(json["sale"]),
      );

  Map<String, dynamic> toJson() => {
        "sale": sale?.toJson(),
      };
}
