import 'package:eventify/models/api_models/pass_response/discount.dart';

class Pass {
  final String? id;
  final String? name;
  final int? fullPrice;
  final Discount? discount;

  Pass({
    this.id,
    this.name,
    this.fullPrice,
    this.discount,
  });

  factory Pass.fromJson(Map<String, dynamic> json) => Pass(
        id: json["id"],
        name: json["name"],
        fullPrice: json["full_price"],
        discount: json["discount"] == null
            ? null
            : Discount.fromJson(json["discount"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "full_price": fullPrice,
        "discount": discount?.toJson(),
      };
}
