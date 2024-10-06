import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/event_bus/refresh_discover_event.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/splash_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/seller/base/events/seller_events_screen.dart';
import 'package:eventify/ui/seller/base/sales/seller_sales_screen.dart';
import 'package:eventify/utils/notification_utils.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class BaseSellerScreen extends StatefulWidget {
  static final eventBus = EventBus();
  const BaseSellerScreen({super.key});

  @override
  State<BaseSellerScreen> createState() => _BaseSellerScreenState();
}

class _BaseSellerScreenState extends State<BaseSellerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StreamSubscription<RemoteMessage>? remoteMessageStream;
  StreamSubscription<RemoteMessage>? onMessageOpenedStream;
  List<Widget> pages = [
    const SellerEventsScreen(),
    const SellerSalesScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: pages.length, vsync: this);

    NotificationUtils.initializeFirebase();

    remoteMessageStream = FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      Map<String, dynamic> notificationData = message.data;

      if (notification != null) {
        if (notificationData["action"] == "open_lister_events" ||
            notificationData["action"] == "open_alerts") {
          // _performNotificationTap(
          //     message.data["action"], message.data["id"].toString());
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    if (remoteMessageStream != null) {
      remoteMessageStream!.cancel();
    }
    if (onMessageOpenedStream != null) {
      onMessageOpenedStream!.cancel();
    }
    super.dispose();
  }

  void _performNotificationTap(String action, String id) {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (action == "open_lister_events") {
        BaseSellerScreen.eventBus.fire(RefreshDiscoverEvents());
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
        elevation: 1,
        backgroundColor: ColorStyle.whiteColor,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: ColorStyle.primaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(accountsRoute);
                },
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: ColorStyle.secondaryTextColor,
                )),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(
            color: ColorStyle.primaryTextColor,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            color: ColorStyle.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: "Events"),
            Tab(text: "Sales"),
          ],
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: pages,
      ),
    );
  }
}
