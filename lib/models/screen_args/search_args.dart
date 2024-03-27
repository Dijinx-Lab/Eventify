import 'package:eventify/models/api_models/event_response/event.dart';

class SearchArgs {
  final String query;
  final List<Event> events;
  final List<Event> originalList;
  final String selectedCity;

  SearchArgs(this.query, this.events, this.originalList, this.selectedCity);
}
