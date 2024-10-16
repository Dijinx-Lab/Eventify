import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/event_bus/refresh_discover_event.dart';
import 'package:eventify/models/event_bus/refresh_saved_events.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/splash_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/accounts/accounts_screen.dart';
import 'package:eventify/ui/alerts/alerts_screen.dart';
import 'package:eventify/ui/discover/event_discover_screen.dart';
import 'package:eventify/ui/discover/sales_discover_screen.dart';
import 'package:eventify/ui/saved/saved_base_screen.dart';
import 'package:eventify/utils/notification_utils.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

class MainScreen extends StatefulWidget {
  final MainArgs args;
  static final eventBus = EventBus();
  const MainScreen({super.key, required this.args});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  StreamSubscription<RemoteMessage>? remoteMessageStream;
  StreamSubscription<RemoteMessage>? onMessageOpenedStream;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _index = 0;

  final List<Widget> _widgets = const [
    EventDiscoverScreen(),
    SalesDiscoverScreen(),
    SavedBaseScreen(),
    AccountsScreen()
  ];

  @override
  initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _index = widget.args.index;

    // MainScreen.eventBus.on<UpdateEventPreference>().listen((ev) async {
    //   Future.delayed(const Duration(milliseconds: 300)).then(
    //     (value) {

    //     },
    //   );
    // });
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
      NotificationUtils.showNotification(message);
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        _performNotificationTap(
            message.data["action"], message.data["id"].toString());
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // RemoteNotification? notification = message.notification;
        // if (notification != null) {
        //   if (notification.body["action"] == "open_lister_events" ||
        //       notificationData["action"] == "open_alerts") {
        //     _performNotificationTap(
        //         message.data["action"], message.data["id"].toString());
        //   }
        //   _performNotificationTap(
        //       message.data["action"], message.data["id"].toString());
        // }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

    if (remoteMessageStream != null) {
      remoteMessageStream!.cancel();
    }
    if (onMessageOpenedStream != null) {
      onMessageOpenedStream!.cancel();
    }
  }

  void _performNotificationTap(String action, String id) {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (action == "open_alerts") {
        EventDiscoverScreen.eventBus.fire(RefreshDiscoverEvents());
        AlertsScreen.eventBus.fire(RefreshDiscoverEvents());
      } else if (action == "open_lister_events") {
        PrefUtils().setIsAppTypeCustomer = false;
        Navigator.of(context).pushNamedAndRemoveUntil(
            initialRoute, (e) => false,
            arguments: SplashArgs(true, MainArgs(0)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(PrefUtils().getToken);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: LazyLoadIndexedStack(index: _index, children: _widgets),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: ColorStyle.secondaryTextColor, width: 0.1))),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined), label: 'Events'),
            BottomNavigationBarItem(
                icon: Icon(Icons.sell_outlined), label: 'Sales'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline), label: 'Saved'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: 'Accounts')
          ],
          type: BottomNavigationBarType.fixed,
          elevation: 3,
          currentIndex: _index,
          showUnselectedLabels: true,
          unselectedFontSize: 10,
          selectedFontSize: 12,
          onTap: (value) {
            if (!PrefUtils().getIsUserLoggedIn) {
              Navigator.of(context).pushNamed(notLoggedInRoute);
            } else {
              _index = value;

              if (_index == 1) {
                SavedBaseScreen.eventBus.fire(RefreshSavedEvents());
              }

              setState(() {});
            }
          },
          backgroundColor: ColorStyle.whiteColor,
          selectedItemColor: ColorStyle.primaryColor,
          unselectedItemColor: ColorStyle.secondaryTextColor,
        ),
      ),
    );
  }
}
