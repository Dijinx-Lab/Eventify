import 'dart:convert';

class UserProfile {
  String? userFirstName;
  String? userLastName;
  String? userEmail;
  String? userPhoneNumber;
  int? age;

  UserProfile({
    this.userFirstName,
    this.userLastName,
    this.userEmail,
    this.userPhoneNumber,
    this.age,
  });

  factory UserProfile.fromRawJson(String str) =>
      UserProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userFirstName: json["userFirstName"],
        userLastName: json["userLastName"],
        userEmail: json["userEmail"],
        userPhoneNumber: json["userPhoneNumber"],
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
        "userFirstName": userFirstName,
        "userLastName": userLastName,
        "userEmail": userEmail,
        "userPhoneNumber": userPhoneNumber,
        "age": age,
      };
}
