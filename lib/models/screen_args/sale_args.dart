class SaleArgs {
  String? eventId;
  bool? listingVisible;
  String? name;
  String? description;
  String? startDateTime;
  String? endDateTime;
  String? linkToStores;
  String? website;
  String? discountDescription;
  List<String>? images;
  String? brandName;

  SaleArgs({
    this.eventId,
    this.listingVisible,
    this.name,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.linkToStores,
    this.website,
    this.discountDescription,
    this.images,
    this.brandName,
  });
}
