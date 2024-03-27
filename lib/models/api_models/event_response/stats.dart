class Stats {
  final int? viewed;
  final int? interested;
  final int? going;
  final int? bookmarked;

  Stats({
    this.viewed,
    this.interested,
    this.going,
    this.bookmarked,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        viewed: json["viewed"],
        interested: json["interested"],
        going: json["going"],
        bookmarked: json["bookmarked"],
      );

  Map<String, dynamic> toJson() => {
        "viewed": viewed,
        "interested": interested,
        "going": going,
        "bookmarked": bookmarked,
      };
}
