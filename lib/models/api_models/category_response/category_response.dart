import 'dart:convert';

import 'package:eventify/models/api_models/category_response/category.dart';

CategoryResponse popularCategoryResponseFromJson(String str) =>
    CategoryResponse.fromJson(json.decode(str));

String popularCategoryResponseToJson(CategoryResponse data) =>
    json.encode(data.toJson());

class CategoryResponse {
  final bool? isSuccess;
  final String? message;
  final List<Category>? data;

  CategoryResponse({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Category>.from(
                json["data"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
