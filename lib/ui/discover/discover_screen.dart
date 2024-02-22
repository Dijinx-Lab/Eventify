import 'dart:convert';

import 'package:eventify/models/api_models/category_response/category.dart';
import 'package:eventify/models/api_models/category_response/category_response.dart';
import 'package:eventify/services/category_service.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/constants/city_list.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/event_list_response/event.dart';
import 'package:eventify/models/api_models/event_list_response/event_list_response.dart';
import 'package:eventify/models/misc_models/city.dart';
import 'package:eventify/models/screen_args/search_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/bottom_sheets/category_list_sheet.dart';
import 'package:eventify/widgets/bottom_sheets/city_list_sheet.dart';
import 'package:eventify/widgets/custom_event_container.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<City> cityList;
  List<Category>? categoryList;
  List<Event>? eventsList;
  String? selectedCity;
  EventService eventService = EventService();
  CategoryService categoryService = CategoryService();

  bool isLoading = true;

  @override
  void initState() {
    cityList = (json.decode(jsonCityList) as List)
        .map((data) => City.fromJson(data))
        .toList();
    selectedCity = "Karachi";
    _getCategories();
    _getEventsList();
    super.initState();
  }

  _getEventsList() {
    setState(() {
      isLoading = true;
      eventsList = null;
    });
    eventService.getEventsByCity(selectedCity ?? "").then((value) async {
      setState(() {
        isLoading = false;
      });

      if (value.error == null) {
        EventListResponse apiResponse = value.snapshot;
        if (apiResponse.isSuccess ?? false) {
          eventsList = apiResponse.data ?? [];
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

  _getCategories({bool isForAll = false}) {
    categoryService.getCategories(isForAll: isForAll).then((value) async {
      if (value.error == null) {
        CategoryResponse apiResponse = value.snapshot;
        if (apiResponse.isSuccess ?? false) {
          categoryList = apiResponse.data;
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
    String searchText = _searchController.text.trim();

    if (searchText != "" && eventsList != null) {
      List<Event> filteredEvents = eventsList!
          .where((event) =>
              event.eventName!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();

      Navigator.of(context).pushNamed(searchRoute,
          arguments: SearchArgs(
              searchText, filteredEvents, eventsList!, selectedCity!));
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
                        _searchEventsList();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _searchEventsList();
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
                    child: const Center(
                      child: Text(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      itemCount: categoryList!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: ColorStyle.primaryColorLight),
                          child: Text(
                            categoryList![index].categoryName ?? "",
                            style:
                                const TextStyle(color: ColorStyle.whiteColor),
                          ),
                        );
                      }),
                ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    constraints: const BoxConstraints(maxWidth: 130),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : eventsList == null
                    ? _errorCard()
                    : eventsList!.isEmpty
                        ? _emptyCaseCard()
                        : ListView.builder(
                            itemCount: eventsList!.length,
                            itemBuilder: (context, index) {
                              return CustomEventContainer(
                                event: eventsList![index],
                              );
                            }),
          )
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
      setState(() {
        selectedCity = city;
      });
      _getEventsList();
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
      builder: (BuildContext context) => const CategoryListSheet(),
    );
    if (category != null) {
      setState(() {
        //selectedCity = city;
      });
      //_getEventsList();
    }
  }
}
