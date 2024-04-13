import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/event_response/event.dart';
import 'package:eventify/models/api_models/event_response/event_list_response.dart';
import 'package:eventify/models/event_bus/refresh_discover_event.dart';
import 'package:eventify/models/event_bus/refresh_my_events.dart';
import 'package:eventify/models/screen_args/create_event_args.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/splash_args.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/notification_utils.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_event_container.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SellerHomeScreen extends StatefulWidget {
  static final eventBus = EventBus();
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  bool isFloatingShown = false;
  List<Event>? eventsList;
  bool isLoading = true;
  EventService eventService = EventService();
  StreamSubscription<RemoteMessage>? remoteMessageStream;
  StreamSubscription<RemoteMessage>? onMessageOpenedStream;

  @override
  void initState() {
    _showAfterDelay();
    _getEventsList();
    super.initState();

    NotificationUtils.initializeFirebase();

    remoteMessageStream = FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      Map<String, dynamic> notificationData = message.data;

      if (notification != null) {
        if (notificationData["action"] == "open_lister_events" ||
            notificationData["action"] == "open_alerts") {
          _performNotificationTap(
              message.data["action"], message.data["id"].toString());
        }

        NotificationUtils.showNotification(message);
      }
    });

    onMessageOpenedStream =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // NotificationUtils.showNotification(message);
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        _performNotificationTap(
            message.data["action"], message.data["id"].toString());
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        RemoteNotification? notification = message.notification;
        if (notification != null) {
          _performNotificationTap(
              message.data["action"], message.data["id"].toString());
        }
      }
    });

    SellerHomeScreen.eventBus.on<RefreshDiscoverEvents>().listen((ev) {
      _getEventsList();
    });
  }

  @override
  dispose() {
    super.dispose();
    if (remoteMessageStream != null) {
      remoteMessageStream!.cancel();
    }
    if (onMessageOpenedStream != null) {
      onMessageOpenedStream!.cancel();
    }
  }

  _showAfterDelay() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      setState(() {
        isFloatingShown = true;
      });
    });

    SellerHomeScreen.eventBus.on<RefreshMyEvents>().listen((event) {
      _getEventsList();
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
          contentText: value.error ?? "",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  void _performNotificationTap(String action, String id) {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (action == "open_lister_events") {
        print('refreshed');
        _getEventsList();
      } else if (action == "open_alerts") {
        PrefUtils().setIsAppTypeCustomer = true;
        Navigator.of(context).pushNamedAndRemoveUntil(
            initialRoute, (e) => false,
            arguments: SplashArgs(true, MainArgs(2, action: action, id: id)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ColorStyle.whiteColor,
        foregroundColor: ColorStyle.secondaryTextColor,
        elevation: 0.5,
        title: const Text(
          "Your Events",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(accountsRoute);
                },
                icon: const Icon(Icons.account_circle_outlined)),
          )
        ],
      ),
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
