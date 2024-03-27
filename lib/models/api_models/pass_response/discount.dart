class Discount {
  final int? discountedPrice;
  final double? percentage;
  final DateTime? lastDate;

  Discount({
    this.discountedPrice,
    this.percentage,
    this.lastDate,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
        discountedPrice: json["discounted_price"],
        percentage: json["percentage"].toDouble(),
        lastDate: json["last_date"] == null
            ? null
            : DateTime.parse(json["last_date"]),
      );

  Map<String, dynamic> toJson() => {
        "discounted_price": discountedPrice,
        "percentage": percentage,
        "last_date": lastDate?.toIso8601String(),
      };
}
