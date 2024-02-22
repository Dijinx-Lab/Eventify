class Category {
  final int? id;
  final String? categoryName;
  final String? categoryDescription;

  Category({
    this.id,
    this.categoryName,
    this.categoryDescription,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["categoryName"],
        categoryDescription: json["categoryDescription"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryName,
        "categoryDescription": categoryDescription,
      };
}
