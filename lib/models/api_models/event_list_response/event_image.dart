import 'dart:convert';

class EventImage {
  String? imagePath;

  EventImage({
    this.imagePath,
  });

  factory EventImage.fromRawJson(String str) =>
      EventImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EventImage.fromJson(Map<String, dynamic> json) => EventImage(
        imagePath: json["imagePath"],
      );

  Map<String, dynamic> toJson() => {
        "imagePath": imagePath,
      };
}
