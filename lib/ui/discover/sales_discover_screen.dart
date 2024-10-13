import 'package:event_bus/event_bus.dart';
import 'package:eventify/models/api_models/sale_response/sale.dart';
import 'package:eventify/models/api_models/sale_response/sale_list_response.dart';
import 'package:eventify/models/event_bus/update_stats_event.dart';
import 'package:eventify/services/sale_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/toast_utils.dart';
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

  SaleService saleService = SaleService();

  bool isEventsLoading = true;

  @override
  void initState() {
    super.initState();
    _getEventsList();
    // _searchController.addListener(() => _searchListings());
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
              DateTime eventTime = DateTime.parse(element.endDateTime!);
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
                )
              ],
            ),
          ),
          Expanded(
            child: isEventsLoading
                ? const Center(child: CircularProgressIndicator())
                : salesList == null
                    ? _errorCard()
                    : salesList!.isEmpty
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
