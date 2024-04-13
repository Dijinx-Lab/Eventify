import 'package:eventify/models/api_models/pass_response/pass.dart';

class EventArgs {
  String? eventId;
  bool? listingVisible;
  String? name;
  String? description;
  String? categoryId;
  String? dateTime;
  String? address;
  String? city;
  double? latitude;
  double? longitude;
  int? maxCapacity;
  String? priceType;
  int? priceStartsFrom;
  int? priceGoesUpto;
  List<String>? images;
  List<Pass>? passes;
  String? contactName;
  String? contactPhone;
  String? contactEmail;
  String? contactWhatsApp;
  String? contactOrganization;

  EventArgs({
    this.eventId,
    this.listingVisible,
    this.name,
    this.description,
    this.categoryId,
    this.dateTime,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.maxCapacity,
    this.priceType,
    this.priceStartsFrom,
    this.priceGoesUpto,
    this.images,
    this.passes,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
    this.contactWhatsApp,
    this.contactOrganization,
  });
}
