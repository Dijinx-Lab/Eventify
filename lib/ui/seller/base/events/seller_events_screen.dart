import 'dart:async';

import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/event_response/event.dart';
import 'package:eventify/models/api_models/event_response/event_list_response.dart';
import 'package:eventify/models/event_bus/refresh_discover_event.dart';
import 'package:eventify/models/event_bus/refresh_my_events.dart';
import 'package:eventify/models/screen_args/create_event_args.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/seller/base/base_seller_screen.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_event_container.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SellerEventsScreen extends StatefulWidget {
  // static final eventBus = EventBus();
  const SellerEventsScreen({super.key});

  @override
  State<SellerEventsScreen> createState() => _SellerEventsScreenState();
}

class _SellerEventsScreenState extends State<SellerEventsScreen> {
  bool isFloatingShown = false;
  List<Event>? eventsList;
  bool isLoading = true;
  EventService eventService = EventService();

  @override
  void initState() {
    _showAfterDelay();
    _getEventsList();
    super.initState();

    BaseSellerScreen.eventBus.on<RefreshDiscoverEvents>().listen((ev) {
      if (mounted) {
        _getEventsList();
      }
    });

    // SellerHomeScreen.eventBus.on<UpdateStatsEvent>().listen((ev) {
    //   int index = eventsList!.indexWhere((element) => element.id == ev.id);
    //   if (index != -1) {
    //     eventsList![index].stats = ev.stats;
    //     setState(() {});
    //   }
    // });
  }

  @override
  dispose() {
    super.dispose();
  }

  _showAfterDelay() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() {
        isFloatingShown = true;
      });
    });

    BaseSellerScreen.eventBus.on<RefreshMyEvents>().listen((event) {
      if (mounted) {
        _getEventsList();
      }
    });
  }

  _getEventsList() {
    setState(() {
      isLoading = true;
      eventsList = null;
    });
    eventService.getEvents("user").then((value) async {
      setState(() {
        isLoading = false;
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
      floatingActionButton: !isFloatingShown
          ? null
          : Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createEventRoute,
                      arguments: CreateEventsArgs(event: null));
                },
                backgroundColor: ColorStyle.primaryColor,
                child: const Icon(
                  Icons.add,
                  size: 35,
                  color: ColorStyle.whiteColor,
                ),
                //isExtended: true,
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventsList == null
              ? _errorCard()
              : eventsList!.isEmpty
                  ? _emptyCaseCard()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemCount: eventsList!.length,
                      itemBuilder: (context, index) {
                        return CustomEventContainer(
                          event: eventsList![index],
                          onBookmarked: (eventId) {},
                        );
                      }),
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
              "You haven't posted any events yet",
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
