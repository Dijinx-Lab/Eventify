import 'package:event_bus/event_bus.dart';
import 'package:eventify/models/api_models/sale_response/sale.dart';
import 'package:eventify/models/api_models/sale_response/sale_list_response.dart';
import 'package:eventify/models/event_bus/update_stats_event.dart';
import 'package:eventify/models/misc_models/sale_filter.dart';
import 'package:eventify/services/sale_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/bottom_sheets/sale_filter_sheet.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_sale_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SalesDiscoverScreen extends StatefulWidget {
  static final eventBus = EventBus();
  const SalesDiscoverScreen({super.key});

  @override
  State<SalesDiscoverScreen> createState() => _SalesDiscoverScreenState();
}

class _SalesDiscoverScreenState extends State<SalesDiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Sale>? salesList;
  List<Sale>? filteredSalesList;
  late SaleFilter saleFilters;
  SaleService saleService = SaleService();

  bool isEventsLoading = true;

  @override
  void initState() {
    super.initState();
    _getEventsList();
    saleFilters = SaleFilter(
      saleLocationType: "both",
      startDateTime: null,
      endDateTime: null,
      sortBy: "relevance",
    );
    SalesDiscoverScreen.eventBus.on<UpdateStatsEvent>().listen((ev) {
      if (filteredSalesList == null || filteredSalesList!.isEmpty) {
        return;
      }
      int index =
          filteredSalesList!.indexWhere((element) => element.id == ev.id);

      if (index != -1) {
        Sale updatedEvent = filteredSalesList![index];
        updatedEvent.preference!.bookmarked = ev.bookmarked;
        updatedEvent.preference!.preference = ev.action;
        filteredSalesList![index] = updatedEvent;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  _checkDefaultFilter() {
    return saleFilters.sortBy == "relevance" &&
        saleFilters.endDateTime == null &&
        saleFilters.startDateTime == null &&
        saleFilters.saleLocationType == "both";
  }

  _searchListings() {
    if (_searchController.text == "") {
      filteredSalesList = List.from(salesList ?? []);
    } else {
      filteredSalesList = salesList
              ?.where((element) => element.name!
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
              .toList() ??
          [];
    }
    FocusManager.instance.primaryFocus?.unfocus();
    _applySaleFilter();
  }

  _applySaleFilter() {
    //DATES

    if (saleFilters.startDateTime != null) {
      filteredSalesList = [
        ...filteredSalesList?.where(
                (e) => e.startDateTime!.isAfter(saleFilters.startDateTime!)) ??
            []
      ];
    }

    if (saleFilters.endDateTime != null) {
      filteredSalesList = [
        ...filteredSalesList?.where(
                (e) => e.endDateTime!.isAfter(saleFilters.endDateTime!)) ??
            []
      ];
    }

    //LOCATION

    if (saleFilters.saleLocationType == "online") {
      filteredSalesList = [
        ...filteredSalesList
                ?.where((e) => e.website != null && e.website != "") ??
            []
      ];
    } else if (saleFilters.saleLocationType == "offline") {
      filteredSalesList = [
        ...filteredSalesList?.where(
                (e) => e.linkToStores != null && e.linkToStores != "") ??
            []
      ];
    }

    //SORTING

    if (saleFilters.sortBy == "relevance") {
      filteredSalesList?.sort((a, b) => b.createdOn!.compareTo(a.createdOn!));
    } else if (saleFilters.sortBy == "dateStarting") {
      filteredSalesList
          ?.sort((a, b) => a.startDateTime!.compareTo(b.startDateTime!));
    } else if (saleFilters.sortBy == "dateEnding") {
      filteredSalesList
          ?.sort((a, b) => a.endDateTime!.compareTo(b.endDateTime!));
    }

    setState(() {});
  }

  _getEventsList() {
    setState(() {
      isEventsLoading = true;
      salesList = null;
      filteredSalesList = null;
    });
    saleService.getSales("all").then((value) async {
      setState(() {
        isEventsLoading = false;
      });

      if (value.error == null) {
        SaleListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          salesList = apiResponse.data?.sales ?? [];
          salesList?.removeWhere(
            (element) {
              DateTime eventTime = element.endDateTime!;
              return eventTime.isBefore(DateTime.now());
            },
          );
          _searchListings();
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
                      decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: ColorStyle.primaryColor,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _searchController.text = '';
                              _searchListings();
                            },
                            splashColor: Colors.transparent,
                            icon: const Icon(
                              Icons.close,
                              color: ColorStyle.secondaryTextColor,
                            ),
                          ),
                          hintStyle: const TextStyle(fontSize: 13),
                          hintText: "Search for a sale",
                          border: InputBorder.none),
                      onSubmitted: (value) {
                        // _getAllEventsList();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _searchListings();
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
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => _openFiltersBottomSheet(),
              child: Container(
                height: 30,
                margin: const EdgeInsets.only(right: 20),
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
                      Icons.filter_list_sharp,
                      size: 20,
                      color: ColorStyle.primaryColor,
                    ),
                    const SizedBox(width: 3),
                    const Flexible(
                      child: Text(
                        "Filters",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorStyle.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (!_checkDefaultFilter())
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: ColorStyle.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Text("1+",
                            style: TextStyle(
                                color: ColorStyle.whiteColor, fontSize: 8)),
                      )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: isEventsLoading
                ? const Center(child: CircularProgressIndicator())
                : salesList == null
                    ? _errorCard()
                    : filteredSalesList!.isEmpty
                        ? _emptyCaseCard()
                        : ListView.builder(
                            itemCount: filteredSalesList!.length,
                            itemBuilder: (context, index) {
                              return CustomSaleContainer(
                                sale: filteredSalesList![index],
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
          ),
        ]),
      ),
    );
  }

  void _openFiltersBottomSheet() async {
    SaleFilter? res = await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) => SaleFilterSheet(
        preFilters: saleFilters,
      ),
    );
    if (res != null) {
      // _setCityAndGetList(city);
      saleFilters = res;
      _searchListings();
    }
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
              "Currently there are no sales to show",
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
}
