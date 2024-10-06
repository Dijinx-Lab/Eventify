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
  String? contactName;
  String? contactPhone;
  String? contactEmail;
  String? contactWhatsApp;
  String? contactOrganization;

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
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.contactWhatsApp,
    this.contactOrganization,
  });
}
