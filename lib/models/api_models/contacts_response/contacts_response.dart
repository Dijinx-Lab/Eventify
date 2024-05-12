// To parse this JSON data, do
//
//     final contactsResponse = contactsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:eventify/models/api_models/contacts_response/user_contact.dart';
import 'package:eventify/models/api_models/event_response/stats.dart';

ContactsResponse contactsResponseFromJson(String str) =>
    ContactsResponse.fromJson(json.decode(str));

String contactsResponseToJson(ContactsResponse data) =>
    json.encode(data.toJson());

class ContactsResponse {
  final bool? success;
  final Data? data;
  final String? message;

  ContactsResponse({
    this.success,
    this.data,
    this.message,
  });

  factory ContactsResponse.fromJson(Map<String, dynamic> json) =>
      ContactsResponse(
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
  final Stats? stats;
  final List<UserContact>? users;

  Data({
    this.stats,
    this.users,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
        users: json["users"] == null
            ? []
            : List<UserContact>.from(json["users"]!.map((x) => UserContact.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "stats": stats?.toJson(),
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}
