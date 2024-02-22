import 'dart:convert';

import 'package:eventify/models/api_models/category_response/category.dart';
import 'package:eventify/models/api_models/event_list_response/event_image.dart';
import 'package:eventify/models/api_models/event_list_response/pass_detail.dart';

class Event {
  int? eventId;
  String? eventName;
  String? organizeBy;
  String? eventDate;
  String? eventTime;
  int? capacity;
  int? categoryId;
  String? address;
  String? city;
  double? latitude;
  double? longitude;
  int? priceStartFrom;
  int? priceGoesUpto;
  String? eventDescription;
  String? contactPersonName;
  String? contactPhoneNumber;
  String? contactWhatsApp;
  String? contactEmail;
  String? userEmailOrPhone;
  Category? category;
  List<EventImage>? eventImages;
  List<PassDetail>? eventPassDetails;

  Event({
    this.eventId,
    this.eventName,
    this.organizeBy,
    this.eventDate,
    this.eventTime,
    this.capacity,
    this.categoryId,
    this.address,
    this.city,
    this.latitude,
    this.longitude,
    this.priceStartFrom,
    this.priceGoesUpto,
    this.eventDescription,
    this.contactPersonName,
    this.contactPhoneNumber,
    this.contactWhatsApp,
    this.contactEmail,
    this.userEmailOrPhone,
    this.category,
    this.eventImages,
    this.eventPassDetails,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        eventId: json["eventId"],
        eventName: json["eventName"],
        organizeBy: json["organizeBy"],
        eventDate: json["eventDate"],
        eventTime: json["eventTime"],
        capacity: json["capacity"],
        categoryId: json["categoryId"],
        address: json["address"],
        city: json["city"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        priceStartFrom: json["priceStartFrom"],
        priceGoesUpto: json["priceGoesUpto"],
        eventDescription: json["eventDescription"],
        contactPersonName: json["contactPersonName"],
        contactPhoneNumber: json["contactPhoneNumber"],
        contactWhatsApp: json["contactWhatsApp"],
        contactEmail: json["contactEmail"],
        userEmailOrPhone: json["userEmailOrPhone"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        eventImages: json["eventImages"] == null
            ? []
            : List<EventImage>.from(
                json["eventImages"]!.map((x) => EventImage.fromJson(x))),
        eventPassDetails: json["eventPassDetails"] == null
            ? []
            : List<PassDetail>.from(
                json["eventPassDetails"]!.map((x) => PassDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonReturn = {
      "eventId": eventId,
      "eventName": eventName,
      "organizeBy": organizeBy,
      "eventDate": eventDate,
      "eventTime": eventTime,
      "capacity": capacity,
      "categoryId": categoryId,
      "address": address,
      "city": city,
      "latitude": latitude,
      "longitude": longitude,
      "priceStartFrom": priceStartFrom,
      "priceGoesUpto": priceGoesUpto,
      "eventDescription": eventDescription,
      "contactPersonName": contactPersonName,
      "contactPhoneNumber": contactPhoneNumber,
      "contactWhatsApp": contactWhatsApp,
      "contactEmail": contactEmail,
      "userEmailOrPhone": userEmailOrPhone,
      "category": category?.toJson(),
      "eventImages": eventImages == null
          ? []
          : List<dynamic>.from(eventImages!.map((x) => x.toJson())),
      "eventPassDetails": eventPassDetails == null
          ? []
          : List<dynamic>.from(eventPassDetails!.map((x) => x.toJson())),
    };
    jsonReturn.removeWhere((key, value) => value == null);

    return jsonReturn;
  }
}
