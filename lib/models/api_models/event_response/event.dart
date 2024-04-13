import 'package:eventify/models/api_models/category_response/category.dart';
import 'package:eventify/models/api_models/event_response/contact.dart';
import 'package:eventify/models/api_models/event_response/preference.dart';
import 'package:eventify/models/api_models/event_response/stats.dart';
import 'package:eventify/models/api_models/pass_response/pass.dart';

class Event {
  String? id;
  String? name;
  String? description;
  String? dateTime;
  String? address;
  String? city;
  double? latitude;
  double? longitude;
  int? maxCapacity;
  String? priceType;
  int? priceStartsFrom;
  int? priceGoesUpto;
  bool? listingVisible;
  bool? myEvent;
  List<String>? images;
  List<Pass>? passes;
  Category? category;
  Contact? contact;
  Stats? stats;
  Preference? preference;
  String? approvedOn;

  Event(
      {this.id,
      this.name,
      this.description,
      this.dateTime,
      this.address,
      this.city,
      this.latitude,
      this.longitude,
      this.maxCapacity,
      this.priceType,
      this.priceStartsFrom,
      this.priceGoesUpto,
      this.listingVisible,
      this.myEvent,
      this.images,
      this.passes,
      this.category,
      this.contact,
      this.stats,
      this.preference,
      this.approvedOn});

  factory Event.fromJson(Map<String, dynamic> json) => Event(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      dateTime: json["date_time"],
      address: json["address"],
      city: json["city"],
      latitude: json["latitude"]?.toDouble(),
      longitude: json["longitude"]?.toDouble(),
      maxCapacity: json["max_capacity"],
      priceType: json["price_type"],
      priceStartsFrom: json["price_starts_from"],
      priceGoesUpto: json["price_goes_upto"],
      listingVisible: json["listing_visibile"],
      myEvent: json["my_event"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      passes: json["passes"] == null
          ? []
          : List<Pass>.from(json["passes"]!.map((x) => Pass.fromJson(x))),
      category:
          json["category"] == null ? null : Category.fromJson(json["category"]),
      contact:
          json["contact"] == null ? null : Contact.fromJson(json["contact"]),
      stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
      preference: json["preference"] == null
          ? null
          : Preference.fromJson(json["preference"]),
      approvedOn: json["approved_on"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "date_time": dateTime,
        "address": address,
        "city": city,
        "latitude": latitude,
        "longitude": longitude,
        "max_capacity": maxCapacity,
        "price_type": priceType,
        "price_starts_from": priceStartsFrom,
        "price_goes_upto": priceGoesUpto,
        "listing_visibile": listingVisible,
        "my_event": myEvent,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "passes": passes == null
            ? []
            : List<dynamic>.from(passes!.map((x) => x.toJson())),
        "category": category?.toJson(),
        "contact": contact?.toJson(),
        "stats": stats?.toJson(),
        "preference": preference?.toJson(),
        "approved_on": approvedOn
      };
}
