import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_bus/event_bus.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/event_response/event.dart';
import 'package:eventify/models/api_models/event_response/event_list_response.dart';
import 'package:eventify/models/event_bus/refresh_discover_event.dart';
import 'package:eventify/models/screen_args/detail_args.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class AlertsScreen extends StatefulWidget {
  static final eventBus = EventBus();
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  List<Event>? eventsList;
  bool isEventsLoading = true;
  EventService eventService = EventService();

  @override
  initState() {
    _getSavedList();
    super.initState();

    AlertsScreen.eventBus.on<RefreshDiscoverEvents>().listen((ev) {
      if (mounted) {
        _getEventsListWithoutLoading();
      }
    });
  }

  _getEventsListWithoutLoading() {
    eventService.getEvents("alerted").then((value) async {
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
          contentText: "Please check your connection and try again later",
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
    eventService.getEvents("alerted").then((value) async {
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
      appBar: AppBar(
        backgroundColor: ColorStyle.whiteColor,
        foregroundColor: ColorStyle.secondaryTextColor,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          "Alerts",
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
                      padding: EdgeInsets.zero,
                      itemCount: eventsList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return _alertsCard(index);
                      }),
    );
  }

  Widget _alertsCard(index) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(detailRoute, arguments: DetailArgs(eventsList![index])),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 100,
        width: MediaQuery.of(context).size.width - 60,
        decoration: BoxDecoration(
            color: ColorStyle.whiteColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  color: ColorStyle.blackColor.withOpacity(0.25))
            ]),
        child: Stack(
          children: [
            Row(
              //mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 80,
                    width: 100,
                    child: CachedNetworkImage(
                        imageUrl: eventsList?[index].images?.first ?? "",
                        errorWidget: (context, url, error) {
                          return Container(
                            color: ColorStyle.secondaryTextColor,
                            child: const Center(
                                child: Icon(
                              Icons.error_outline,
                              color: ColorStyle.whiteColor,
                            )),
                          );
                        },
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      eventsList?[index].name ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ColorStyle.primaryTextColor,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.assignment_ind_outlined,
                            color: ColorStyle.secondaryTextColor, size: 14),
                        const SizedBox(
                          width: 3,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          eventsList?[index].contact?.name ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: ColorStyle.secondaryTextColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              bottom: 5,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.schedule,
                          color: ColorStyle.primaryColor, size: 14),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        DateFormat('h:mm a').format(
                            DateTime.parse(eventsList![index].dateTime!)),

                        //"9:30 PM",
                        style: const TextStyle(
                          color: ColorStyle.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.today_outlined,
                          color: ColorStyle.primaryColor, size: 14),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        DateFormat('MMM d, y').format(
                            DateTime.parse(eventsList![index].dateTime!)),
                        style: const TextStyle(
                          color: ColorStyle.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
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
              "Currently there are no new events near you",
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
