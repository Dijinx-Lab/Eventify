import 'package:eventify/models/api_models/sale_response/sale.dart';
import 'package:eventify/models/api_models/sale_response/sale_list_response.dart';
import 'package:eventify/models/event_bus/refresh_saved_events.dart';
import 'package:eventify/models/event_bus/update_stats_event.dart';
import 'package:eventify/services/sale_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/saved/saved_base_screen.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_sale_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SavedSalesScreen extends StatefulWidget {
  const SavedSalesScreen({super.key});

  @override
  State<SavedSalesScreen> createState() => _SavedSalesScreenState();
}

class _SavedSalesScreenState extends State<SavedSalesScreen> {
  List<Sale>? eventsList;
  bool isEventsLoading = true;
  SaleService eventService = SaleService();

  @override
  void initState() {
    _getSavedList();
    super.initState();
    SavedBaseScreen.eventBus.on<UpdateStatsEvent>().listen((ev) {
      if (mounted) {
        if (eventsList == null || eventsList!.isEmpty || !mounted) {
          return;
        }
        int index = eventsList!.indexWhere((element) => element.id == ev.id);

        if (index != -1) {
          eventsList!.removeAt(index);
          setState(() {});
        }
      }
    });

    SavedBaseScreen.eventBus.on<RefreshSavedEvents>().listen((ev) {
      if (mounted) {
        _getSavedList();
      }
    });
  }

  _getSavedList() {
    setState(() {
      isEventsLoading = true;
      eventsList = null;
    });
    eventService.getSales("bookmarked").then((value) async {
      setState(() {
        isEventsLoading = false;
      });

      if (value.error == null) {
        SaleListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          setState(() {
            eventsList = apiResponse.data?.sales ?? [];
          });
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
    return Scaffold(
      body: isEventsLoading
          ? const Center(child: CircularProgressIndicator())
          : eventsList == null
              ? _errorCard()
              : eventsList!.isEmpty
                  ? _emptyCaseCard()
                  : ListView.builder(
                      itemCount: eventsList!.length,
                      itemBuilder: (context, index) {
                        return CustomSaleContainer(
                          sale: eventsList![index],
                          onBookmarked: (eventId) {
                            // int index = eventsList!
                            //     .indexWhere((event) => event.id == eventId);
                            // if (index != -1) {
                            //   eventsList![index].preference!.bookmarked =
                            //       !eventsList![index].preference!.bookmarked!;
                            //   _saveEventPrefs(eventsList![index]);
                            // }
                          },
                        );
                      }),
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
                  _getSavedList();
                }))
          ],
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
            const Text(
              "Currently there are no saved sales",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, color: ColorStyle.secondaryTextColor),
            ),
            const SizedBox(height: 25),
            SizedBox(
                width: 200,
                height: 40,
                child: CustomRoundedButton("Refresh", () {
                  _getSavedList();
                }))
          ],
        ),
      ),
    );
  }
}
