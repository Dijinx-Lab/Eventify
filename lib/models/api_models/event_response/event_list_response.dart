// To parse this JSON data, do
//
//     final eventListResponse = eventListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:eventify/models/api_models/event_response/event.dart';

EventListResponse eventListResponseFromJson(String str) =>
    EventListResponse.fromJson(json.decode(str));

String eventListResponseToJson(EventListResponse data) =>
    json.encode(data.toJson());

class EventListResponse {
  final bool? success;
  final Data? data;
  final String? message;

  EventListResponse({
    this.success,
    this.data,
    this.message,
  });

  factory EventListResponse.fromJson(Map<String, dynamic> json) =>
      EventListResponse(
        success: json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  final List<Event>? events;

  Data({
    this.events,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        events: json["events"] == null
            ? []
            : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "events": events == null
            ? []
            : List<dynamic>.from(events!.map((x) => x.toJson())),
      };
}


