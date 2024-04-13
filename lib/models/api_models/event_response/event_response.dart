import 'dart:convert';

import 'package:eventify/models/api_models/event_response/event.dart';

EventResponse eventResponseFromJson(String str) =>
    EventResponse.fromJson(json.decode(str));

String eventResponseToJson(EventResponse data) => json.encode(data.toJson());

class EventResponse {
  final bool? success;
  final Data? data;
  final String? message;

  EventResponse({
    this.success,
    this.data,
    this.message,
  });

  factory EventResponse.fromJson(Map<String, dynamic> json) => EventResponse(
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
  final Event? event;

  Data({
    this.event,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        event: json["event"] == null ? null : Event.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "event": event?.toJson(),
      };
}
