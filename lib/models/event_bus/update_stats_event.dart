import 'package:eventify/models/api_models/event_response/stats.dart';

class UpdateStatsEvent {
  final Stats? stats;
  final String id;
  final bool? bookmarked;
  UpdateStatsEvent({required this.id, this.stats, this.bookmarked});
}
