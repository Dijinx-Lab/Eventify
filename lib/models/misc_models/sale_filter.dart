class SaleFilter {
  String? saleLocationType;
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? sortBy;

  SaleFilter({
    required this.saleLocationType,
    required this.startDateTime,
    required this.endDateTime,
    required this.sortBy,
  });
}
