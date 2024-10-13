import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:eventify/models/api_models/category_response/category.dart';
import 'package:eventify/models/api_models/category_response/category_list_response.dart';
import 'package:eventify/models/event_bus/refresh_discover_event.dart';
import 'package:eventify/models/event_bus/update_stats_event.dart';
import 'package:eventify/services/category_service.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/constants/city_list.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/event_response/event.dart';
import 'package:eventify/models/api_models/event_response/event_list_response.dart';
import 'package:eventify/models/misc_models/city.dart';
import 'package:eventify/models/screen_args/search_args.dart';
import 'package:eventify/services/user_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/bottom_sheets/category_list_sheet.dart';
import 'package:eventify/widgets/bottom_sheets/city_list_sheet.dart';
import 'package:eventify/widgets/custom_event_container.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class EventDiscoverScreen extends StatefulWidget {
  static final eventBus = EventBus();
  const EventDiscoverScreen({super.key});

  @override
  State<EventDiscoverScreen> createState() => _EventDiscoverScreenState();
}

class _EventDiscoverScreenState extends State<EventDiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<City> cityList;
  List<Category>? categoryList;
  List<Category>? popularCategoryList;
  List<Event>? eventsList;
  List<Event>? filteredEventsList;
  List<Event>? allEventsList;
  String? selectedCity;
  Category? selectedCategory;
  EventService eventService = EventService();
  CategoryService categoryService = CategoryService();

  bool isCategoriesLoading = true;
  bool isEventsLoading = true;
  bool isSearchButtonLoading = false;

  @override
  void initState() {
    cityList = (json.decode(jsonCityList) as List)
        .map((data) => City.fromJson(data))
        .toList();
    _checkLocationPermission();
    _getCategories();

    EventDiscoverScreen.eventBus.on<RefreshDiscoverEvents>().listen((ev) {
      _getEventsListWithoutLoading();
    });

    EventDiscoverScreen.eventBus.on<UpdateStatsEvent>().listen((ev) {
      if (filteredEventsList == null || filteredEventsList!.isEmpty) {
        return;
      }
      int index =
          filteredEventsList!.indexWhere((element) => element.id == ev.id);

      if (index != -1) {
        Event updatedEvent = filteredEventsList![index];
        updatedEvent.preference!.bookmarked = ev.bookmarked;
        updatedEvent.preference!.preference = ev.action;
        filteredEventsList![index] = updatedEvent;
        if (mounted) {
          setState(() {});
        }
      }
    });

    super.initState();
  }

  _setCityAndGetList(String city) {
    setState(() {
      selectedCity = city;
    });

    _getEventsList();
  }

  _applyCategoryAsFilter() {
    if (selectedCategory == null) {
      filteredEventsList = eventsList;
    } else {
      filteredEventsList = eventsList!.where((element) {
        return element.category?.id == selectedCategory!.id;
      }).toList();
    }
    setState(() {});
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _setCityAndGetList(
          PrefUtils().getCity == "" ? "Karachi" : PrefUtils().getCity);

      return;
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setCityAndGetList(
            PrefUtils().getCity == "" ? "Karachi" : PrefUtils().getCity);

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _setCityAndGetList(
          PrefUtils().getCity == "" ? "Karachi" : PrefUtils().getCity);

      return;
    }

    _getCurrentCity();
  }

  Future<void> _getCurrentCity() async {
    String city = "Karachi";
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark mostLikelyPlace = placemarks[0];
        city = mostLikelyPlace.locality ?? 'Karachi';
      }
    } catch (e) {
      city = "Karachi";
    }
    PrefUtils().setCity = city;
    _setCityAndGetList(city);
    if (PrefUtils().getIsUserLoggedIn) {
      await UserService()
          .updateProfile(null, null, null, null, city, null, null, null);
    }
  }

  _getEventsList() {
    setState(() {
      isEventsLoading = true;
      eventsList = null;
    });
    eventService.getEvents(selectedCity ?? "").then((value) async {
      setState(() {
        isEventsLoading = false;
      });

      if (value.error == null) {
        EventListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          eventsList = apiResponse.data?.events ?? [];
          eventsList?.removeWhere(
            (element) {
              DateTime eventTime = DateTime.parse(element.dateTime!);
              return eventTime.isBefore(DateTime.now());
            },
          );
          _applyCategoryAsFilter();
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
          contentText: "Please check your connection and try again later",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  _getEventsListWithoutLoading() {
    eventService.getEvents(selectedCity ?? "").then((value) async {
      if (value.error == null) {
        EventListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          eventsList = null;
          eventsList = apiResponse.data?.events ?? [];
          _applyCategoryAsFilter();
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
          contentText: "Please check your connection and try again later",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  _getAllEventsList() {
    setState(() {
      isSearchButtonLoading = true;
      allEventsList = null;
    });
    eventService.getEvents("all").then((value) async {
      setState(() {
        isSearchButtonLoading = false;
      });

      if (value.error == null) {
        EventListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          allEventsList = apiResponse.data?.events ?? [];
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
          contentText: "Please check your connection and try again later",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  _getCategories() {
    setState(() {
      isCategoriesLoading = true;
    });
    categoryService.getCategories().then((value) async {
      setState(() {
        isCategoriesLoading = false;
      });
      if (value.error == null) {
        CategoryListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          categoryList = apiResponse.data?.categories ?? [];
          popularCategoryList = categoryList!.take(5).toList();
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
          contentText: "Please check your connection and try again later",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  _searchEventsList() {
    String searchText = _searchController.text.trim();

    if (allEventsList != null) {
      if (searchText == "") {
        Navigator.of(context).pushNamed(searchRoute,
            arguments: SearchArgs(
                searchText, allEventsList!, allEventsList!, selectedCity!));
      } else {
        List<Event> filteredEvents = allEventsList!
            .where((event) =>
                event.name!.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
        Navigator.of(context).pushNamed(searchRoute,
            arguments: SearchArgs(
                searchText, filteredEvents, allEventsList!, selectedCity!));
      }

      _searchController.text = "";
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
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
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
                              color: ColorStyle.blackColor.withOpacity(0.25))
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
                        _getAllEventsList();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _getAllEventsList();
                  },
                  child: Container(
                    width: 80,
                    height: 45,
                    decoration: BoxDecoration(
                        color: ColorStyle.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              color: ColorStyle.blackColor.withOpacity(0.25))
                        ]),
                    child: Center(
                      child: isSearchButtonLoading
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                color: ColorStyle.whiteColor,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Search",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: ColorStyle.whiteColor,
                              ),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: isCategoriesLoading || isEventsLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            const Text(
                              "Popular Categories",
                              style: TextStyle(
                                  color: ColorStyle.primaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            TextButton(
                                onPressed: () {
                                  _openCategoryBottomSheet(context);
                                },
                                child: const Text(
                                  "See all",
                                  style: TextStyle(
                                      color: ColorStyle.primaryColor,
                                      fontSize: 14,
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        ),
                      ),
                      categoryList == null
                          ? Container()
                          : Container(
                              height: 30,
                              padding: const EdgeInsets.only(left: 20),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: popularCategoryList!.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        if (selectedCategory ==
                                            popularCategoryList![index]) {
                                          selectedCategory = null;
                                        } else {
                                          selectedCategory =
                                              popularCategoryList![index];
                                        }
                                        _applyCategoryAsFilter();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color:
                                                ColorStyle.primaryColorLight),
                                        child: Row(
                                          children: [
                                            Text(
                                              popularCategoryList![index]
                                                      .name ??
                                                  "",
                                              style: const TextStyle(
                                                  color: ColorStyle.whiteColor),
                                            ),
                                            Visibility(
                                                visible: selectedCategory ==
                                                    popularCategoryList![index],
                                                child: const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Icon(
                                                      Icons.cancel_outlined,
                                                      color:
                                                          ColorStyle.whiteColor,
                                                      size: 18),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            const Text(
                              "Near You",
                              style: TextStyle(
                                  color: ColorStyle.primaryTextColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                _openCityBottomSheet(context);
                              },
                              child: Container(
                                // width: 130,
                                height: 30,
                                constraints:
                                    const BoxConstraints(maxWidth: 130),
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
                                        selectedCity ?? "Loading...",
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
                          ],
                        ),
                      ),
                      Expanded(
                        child: eventsList == null
                            ? _errorCard()
                            : eventsList!.isEmpty
                                ? _emptyCaseCard()
                                : ListView.builder(
                                    itemCount: filteredEventsList!.length,
                                    itemBuilder: (context, index) {
                                      return CustomEventContainer(
                                        event: filteredEventsList![index],
                                        onBookmarked: (eventId) {
                                          // int index = eventsList!.indexWhere(
                                          //     (event) => event.id == eventId);
                                          // if (index != -1) {
                                          //   eventsList![index]
                                          //           .preference!
                                          //           .bookmarked =
                                          //       !eventsList![index]
                                          //           .preference!
                                          //           .bookmarked!;
                                          //   _saveEventPrefs(eventsList![index]);
                                          //   _applyCategoryAsFilter();
                                          // }
                                        },
                                      );
                                    }),
                      )
                    ],
                  ),
          ),
        ]),
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
                  _getCategories();
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
                  _getCategories();
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
      _setCityAndGetList(city);
    }
  }

  void _openCategoryBottomSheet(BuildContext context) async {
    Category? category = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => CategoryListSheet(
        categoryList: categoryList ?? [],
      ),
    );
    if (category != null) {
      if (!popularCategoryList!.contains(category)) {
        popularCategoryList!.insert(0, category);
        popularCategoryList!.removeLast();
      }
      selectedCategory = category;
      _applyCategoryAsFilter();
      setState(() {});
    }
  }
}
