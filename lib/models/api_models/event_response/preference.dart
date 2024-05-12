class Preference {
  bool? bookmarked;
  String? preference;

  Preference({
    this.bookmarked,
    this.preference,
  });

  factory Preference.fromJson(Map<String, dynamic> json) => Preference(
        bookmarked: json["bookmarked"],
        preference: json["preference"],
      );

  Map<String, dynamic> toJson() => {
        "bookmarked": bookmarked,
        "preference": preference,
      };
}
