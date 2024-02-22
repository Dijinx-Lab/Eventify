import 'dart:convert';

import 'package:eventify/services/event_service.dart';
import 'package:eventify/constants/city_list.dart';
import 'package:eventify/models/api_models/event_list_response/event.dart';
import 'package:eventify/models/api_models/event_list_response/event_list_response.dart';
import 'package:eventify/models/misc_models/city.dart';
import 'package:eventify/models/screen_args/search_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/toast_utils.dart';
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
  EventService eventService = EventService();
  late List<City> cityList;

  @override
  void initState() {
    _searchController.text = widget.args.query;
    searchEvents = widget.args.events;
    originalEvents = widget.args.originalList;
    cityList = (json.decode(jsonCityList) as List)
        .map((data) => City.fromJson(data))
        .toList();
    selectedCity = widget.args.selectedCity;
    super.initState();
  }

  _getEventsList() {
    setState(() {
      isLoading = true;
      searchEvents = null;
    });
    eventService.getEventsByCity(selectedCity ?? "").then((value) async {
      setState(() {
        isLoading = false;
      });

      if (value.error == null) {
        EventListResponse apiResponse = value.snapshot;
        if (apiResponse.isSuccess ?? false) {
          originalEvents = apiResponse.data ?? [];
          _searchEventsList();
        } else {
          ToastUtils.showCustomSnackbar(
            context: context,
            contentText: apiResponse.message ?? "",
            icon: const Icon(
              Icons.cancel_outlined,
              color: ColorStyle.whiteColor,
            ),
          );
        }
      } else {
        ToastUtils.showCustomSnackbar(
          context: context,
          contentText: value.error ?? "",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  _searchEventsList() {
    setState(() {
      isLoading = true;
    });
    String searchText = _searchController.text.trim();

    if (searchText == "") {
      setState(() {
        searchEvents = originalEvents;
      });
    } else {
      List<Event> filteredEvents = originalEvents!
          .where((event) =>
              event.eventName!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
      setState(() {
        searchEvents = filteredEvents;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
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
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: ColorStyle.primaryColor,
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
                      onTap: () {
                        _openBottomSheet(context);
                      },
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
                                selectedCity ?? "",
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
                                  );
                                }),
              )
            ],
          ),
        ));
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
            const Text(
              "Currently there are no events to show",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, color: ColorStyle.secondaryTextColor),
            ),
            const SizedBox(height: 25),
            SizedBox(
                width: 200,
                height: 40,
                child: CustomRoundedButton("Refresh", () {
                  _getEventsList();
                }))
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
                  _getEventsList();
                }))
          ],
        ),
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
            height: 600,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
            child: Column(
              children: [
                Container(
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                      color: ColorStyle.secondaryTextColor,
                      borderRadius: BorderRadius.circular(8)),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) => TextButton(
                          style: const ButtonStyle(
                              alignment: Alignment.centerLeft),
                          onPressed: () {
                            setState(() {
                              selectedCity = cityList[index].name;
                            });
                            _getEventsList();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            cityList[index].name ?? "",
                            style: const TextStyle(
                                color: ColorStyle.primaryTextColor,
                                fontWeight: FontWeight.w600),
                          )),
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: cityList.length),
                ),
              ],
            ));
      },
    );
  }
}
