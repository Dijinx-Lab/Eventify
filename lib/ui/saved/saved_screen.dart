import 'package:event_bus/event_bus.dart';
import 'package:eventify/models/api_models/event_response/event.dart';
import 'package:eventify/models/api_models/event_response/event_list_response.dart';
import 'package:eventify/models/event_bus/refresh_discover_event.dart';
import 'package:eventify/models/event_bus/refresh_saved_events.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/services/stats_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_event_container.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SavedScreen extends StatefulWidget {
  static final eventBus = EventBus();
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Event>? eventsList;
  bool isEventsLoading = true;
  EventService eventService = EventService();

  @override
  void initState() {
    _getSavedList();
    super.initState();
    SavedScreen.eventBus.on<RefreshSavedEvents>().listen((ev) {
      _getEventsListWithoutLoading();
    });
  }

  _getEventsListWithoutLoading() {
    eventService.getEvents("bookmarked").then((value) async {
      if (value.error == null) {
        EventListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          setState(() {
            eventsList = null;
            eventsList = apiResponse.data?.events ?? [];
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
          contentText: value.error ?? "",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  _getSavedList() {
    setState(() {
      isEventsLoading = true;
      eventsList = null;
    });
    eventService.getEvents("bookmarked").then((value) async {
      setState(() {
        isEventsLoading = false;
      });

      if (value.error == null) {
        EventListResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          setState(() {
            eventsList = apiResponse.data?.events ?? [];
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
          contentText: value.error ?? "",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  _saveEventPrefs(Event event) async {
    await StatsService().updateStats(
        event.preference!.preference, event.preference!.bookmarked, event.id!);

    SavedScreen.eventBus.fire(RefreshDiscoverEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.whiteColor,
        foregroundColor: ColorStyle.secondaryTextColor,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          "Saved Events",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: isEventsLoading
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
                          onBookmarked: (eventId) {
                            int index = eventsList!
                                .indexWhere((event) => event.id == eventId);
                            if (index != -1) {
                              eventsList![index].preference!.bookmarked =
                                  !eventsList![index].preference!.bookmarked!;
                              _saveEventPrefs(eventsList![index]);
                            }
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
              "Currently there are no saved events",
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
