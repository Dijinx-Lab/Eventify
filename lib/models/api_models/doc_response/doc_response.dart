// To parse this JSON data, do
//
//     final docResponse = docResponseFromJson(jsonString);

import 'dart:convert';

DocResponse docResponseFromJson(String str) =>
    DocResponse.fromJson(json.decode(str));

String docResponseToJson(DocResponse data) => json.encode(data.toJson());

class DocResponse {
  final bool? success;
  final Data? data;
  final String? message;

  DocResponse({
    this.success,
    this.data,
    this.message,
  });

  factory DocResponse.fromJson(Map<String, dynamic> json) => DocResponse(
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
  final Doc? doc;

  Data({
    this.doc,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        doc: json["doc"] == null ? null : Doc.fromJson(json["doc"]),
      );

  Map<String, dynamic> toJson() => {
        "doc": doc?.toJson(),
      };
}

class Doc {
  final String? type;
  final String? text;

  Doc({
    this.type,
    this.text,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        type: json["type"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "text": text,
      };
}
