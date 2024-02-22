import 'dart:convert';

import 'package:eventify/models/api_models/event_list_response/event.dart';

class EventListResponse {
  bool? isSuccess;
  String? message;
  List<Event>? data;

  EventListResponse({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory EventListResponse.fromRawJson(String str) =>
      EventListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventListResponse.fromJson(Map<String, dynamic> json) =>
      EventListResponse(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Event>.from(json["data"]!.map((x) => Event.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
