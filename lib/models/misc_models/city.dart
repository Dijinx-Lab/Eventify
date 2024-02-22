import 'dart:convert';

class City {
  String? country;
  String? name;
  String? lat;
  String? lng;

  City({
    this.country,
    this.name,
    this.lat,
    this.lng,
  });

  factory City.fromRawJson(String str) => City.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory City.fromJson(Map<String, dynamic> json) => City(
        country: json["country"],
        name: json["name"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "name": name,
        "lat": lat,
        "lng": lng,
      };
}
