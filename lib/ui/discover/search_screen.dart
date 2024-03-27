import 'dart:convert';
import 'package:eventify/constants/city_list.dart';
import 'package:eventify/models/api_models/event_response/event.dart';
import 'package:eventify/models/misc_models/city.dart';
import 'package:eventify/models/screen_args/search_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/widgets/bottom_sheets/city_list_sheet.dart';
import 'package:eventify/widgets/custom_event_container.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchScreen extends StatefulWidget {
  final SearchArgs args;
  const SearchScreen({super.key, required this.args});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Event>? searchEvents;
  List<Event>? originalEvents;
  bool isLoading = false;
  String? selectedCity;
  // EventService eventService = EventService();
  late List<City> cityList;

  @override
  void initState() {
    _searchController.text = widget.args.query;
    searchEvents = widget.args.events;
    originalEvents = widget.args.originalList;
    cityList = (json.decode(jsonCityList) as List)
        .map((data) => City.fromJson(data))
        .toList();
    _searchController.addListener(() => _searchEventsList());
    super.initState();
  }

  _searchEventsList() {
    String searchText = _searchController.text.trim();

    if (searchText == "") {
      setState(() {
        searchEvents = originalEvents;
      });
    } else {
      List<Event> filteredEvents = originalEvents!
          .where((event) =>
              event.name!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      searchEvents = filteredEvents;
      if (selectedCity != null) {
        _applyCityAsFilter();
      } else {
        setState(() {});
      }
    }
  }

  _applyCityAsFilter() {
    if (selectedCity != null) {
      List<Event> filteredEvents = searchEvents!
          .where((event) =>
              event.city!.toLowerCase().contains(selectedCity!.toLowerCase()))
          .toList();
      setState(() {
        searchEvents = filteredEvents;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                            color: ColorStyle.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      ColorStyle.blackColor.withOpacity(0.25))
                            ]),
                        child: const Center(
                            child: Icon(
                          Icons.arrow_back,
                          color: ColorStyle.secondaryTextColor,
                        )),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: ColorStyle.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      ColorStyle.blackColor.withOpacity(0.25))
                            ]),
                        child: TextField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                              ),
                              suffixIcon: IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  if (selectedCity != null) {
                                    setState(() {
                                      selectedCity = null;
                                    });
                                    _searchEventsList();
                                  } else {
                                    selectedCity = PrefUtils().getCity;
                                    _searchEventsList();
                                  }
                                },
                                icon: Icon(
                                  Icons.my_location_outlined,
                                  color: selectedCity == PrefUtils().getCity
                                      ? ColorStyle.primaryColor
                                      : ColorStyle.secondaryTextColor,
                                ),
                              ),
                              hintStyle: TextStyle(fontSize: 13),
                              hintText: "Search for an event",
                              border: InputBorder.none),
                          onSubmitted: (value) {
                            _searchEventsList();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _openCityBottomSheet(context),
                      child: Container(
                        // width: 130,
                        height: 30,
                        constraints: const BoxConstraints(maxWidth: 130),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                            color: ColorStyle.primaryColorExtraLight,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: ColorStyle.primaryColor,
                            ),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                selectedCity ?? "Select City...",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ColorStyle.primaryTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 80,
                      height: 30,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: ColorStyle.primaryColorExtraLight,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            size: 20,
                            color: ColorStyle.primaryColor,
                          ),
                          SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              "Filters",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorStyle.primaryTextColor,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : searchEvents == null
                        ? _errorCard()
                        : searchEvents!.isEmpty
                            ? _emptyCaseCard()
                            : ListView.builder(
                                padding: const EdgeInsets.only(top: 0),
                                itemCount: searchEvents!.length,
                                itemBuilder: (context, index) {
                                  return CustomEventContainer(
                                    event: searchEvents![index],
                                    onBookmarked: (eventId) {},
                                  );
                                },
                              ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _emptyCaseCard() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: SvgPicture.asset(
                'assets/svgs/ic_empty_search.svg',
                fit: BoxFit.contain,
              ),
            ),
            Text(
              selectedCity == null
                  ? "No events found by the name \"${_searchController.text}\""
                  : "No events found by the name \"${_searchController.text}\" in ${selectedCity ?? ""}",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, color: ColorStyle.secondaryTextColor),
            ),
          ],
        ),
      ),
    );
  }

  _errorCard() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: SvgPicture.asset(
                'assets/svgs/ic_error_ocurred.svg',
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              "An error occured on our end, please try again in a few moments",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, color: ColorStyle.secondaryTextColor),
            ),
            const SizedBox(height: 25),
            SizedBox(
                width: 200,
                height: 40,
                child: CustomRoundedButton("Refresh", () {
                  // _getEventsList();
                }))
          ],
        ),
      ),
    );
  }

  void _openCityBottomSheet(BuildContext context) async {
    String? city = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => CityListSheet(cityList: cityList),
    );
    if (city != null) {
      selectedCity = city;
      _searchEventsList();
    }
  }
}
