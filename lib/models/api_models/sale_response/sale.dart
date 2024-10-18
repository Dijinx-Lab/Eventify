import 'dart:convert';

import 'package:eventify/models/api_models/event_response/contact.dart';
import 'package:eventify/models/api_models/event_response/preference.dart';
import 'package:eventify/models/api_models/event_response/stats.dart';

class Sale {
  String? id;
  bool? listingVisibile;
  String? name;
  String? description;
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? linkToStores;
  String? website;
  String? discountDescription;
  List<String>? images;
  Contact? contact;
  Stats? stats;
  DateTime? approvedOn;
  bool? myEvent;
  Preference? preference;
  DateTime? createdOn;
  DateTime? deletedOn;

  Sale({
    this.id,
    this.listingVisibile,
    this.name,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.linkToStores,
    this.website,
    this.discountDescription,
    this.images,
    this.contact,
    this.stats,
    this.approvedOn,
    this.myEvent,
    this.preference,
    this.createdOn,
    this.deletedOn,
  });

  factory Sale.fromRawJson(String str) => Sale.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        id: json["id"],
        listingVisibile: json["listing_visibile"],
        name: json["name"],
        description: json["description"],
        startDateTime: json["start_date_time"] == null
            ? null
            : DateTime.parse(json["start_date_time"]),
        endDateTime: json["end_date_time"] == null
            ? null
            : DateTime.parse(json["end_date_time"]),
        linkToStores: json["link_to_stores"],
        website: json["website"],
        discountDescription: json["discount_description"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        contact:
            json["contact"] == null ? null : Contact.fromJson(json["contact"]),
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        approvedOn: json["approved_on"] == null
            ? null
            : DateTime.parse(json["approved_on"]),
        myEvent: json["my_event"],
        preference: json["preference"] == null
            ? null
            : Preference.fromJson(json["preference"]),
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        deletedOn: json["deleted_on"] == null
            ? null
            : DateTime.parse(json["deleted_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "listing_visibile": listingVisibile,
        "name": name,
        "description": description,
        "start_date_time": startDateTime?.toIso8601String(),
        "end_date_time": endDateTime?.toIso8601String(),
        "link_to_stores": linkToStores,
        "website": website,
        "discount_description": discountDescription,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "contact": contact?.toJson(),
        "stats": stats?.toJson(),
        "approved_on": approvedOn?.toIso8601String(),
        "my_event": myEvent,
        "preference": preference?.toJson(),
        "created_on": createdOn?.toIso8601String(),
        "deleted_on": deletedOn?.toIso8601String(),
      };
}
