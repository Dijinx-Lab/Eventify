import 'dart:convert';

import 'package:eventify/models/api_models/sale_response/sale.dart';

class SaleListResponse {
  final bool? success;
  final Data? data;
  final String? message;

  SaleListResponse({
    this.success,
    this.data,
    this.message,
  });

  factory SaleListResponse.fromRawJson(String str) =>
      SaleListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SaleListResponse.fromJson(Map<String, dynamic> json) =>
      SaleListResponse(
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
  final List<Sale>? sales;

  Data({
    this.sales,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sales: json["sales"] == null
            ? []
            : List<Sale>.from(json["sales"]!.map((x) => Sale.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "sales": sales == null
            ? []
            : List<dynamic>.from(sales!.map((x) => x.toJson())),
      };
}
