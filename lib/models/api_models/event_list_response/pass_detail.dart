import 'dart:convert';

class PassDetail {
  int? id;
  int? passPrice;
  int? discountPercent;
  int? dicountedPrice;
  DateTime? discountEndDate;
  String? passInfo;

  PassDetail({
    this.id,
    this.passPrice,
    this.discountPercent,
    this.dicountedPrice,
    this.discountEndDate,
    this.passInfo,
  });

  factory PassDetail.fromRawJson(String str) =>
      PassDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PassDetail.fromJson(Map<String, dynamic> json) => PassDetail(
        id: json["id"],
        passPrice: json["passPrice"],
        discountPercent: json["discountPercent"],
        dicountedPrice: json["dicountedPrice"],
        discountEndDate: json["discountEndDate"] == null
            ? null
            : DateTime.parse(json["discountEndDate"]),
        passInfo: json["passInfo"],
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonReturn = {
      "id": id,
      "passPrice": passPrice,
      "discountPercent": discountPercent,
      "dicountedPrice": dicountedPrice,
      "discountEndDate": discountEndDate?.toIso8601String(),
      "passInfo": passInfo,
    };
    jsonReturn.removeWhere((key, value) => value == null);

    return jsonReturn;
  }
}
