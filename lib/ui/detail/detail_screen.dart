import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/event_response/event.dart';
import 'package:eventify/models/api_models/event_response/event_response.dart';
import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/models/event_bus/refresh_discover_event.dart';
import 'package:eventify/models/event_bus/refresh_my_events.dart';
import 'package:eventify/models/event_bus/update_event_preference.dart';
import 'package:eventify/models/screen_args/create_event_args.dart';
import 'package:eventify/models/screen_args/detail_args.dart';
import 'package:eventify/services/event_service.dart';
import 'package:eventify/services/stats_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/main/main_screen.dart';
import 'package:eventify/ui/seller/home/seller_home_screen.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/bottom_sheets/location_detail_sheet.dart';
import 'package:eventify/widgets/bottom_sheets/pass_details_sheet.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final DetailArgs args;
  const DetailScreen({super.key, required this.args});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with WidgetsBindingObserver {
  String? action;
  bool? bookmarked;
  late Event event;
  final PageController _pageController =
      PageController(viewportFraction: 1, keepPage: true);
  int currentPage = 0;
  StatsService statsService = StatsService();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    event = widget.args.event;
    if (event.preference != null) {
      action = event.preference!.preference;
      bookmarked = event.preference!.bookmarked;
    }
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    final isBackgrond = state == AppLifecycleState.paused;
    if (isBackgrond) {
      _saveEventPrefs();
    }
  }

  _saveEventPrefs() async {
    if (event.myEvent ?? false) {
      return;
    }
    MainScreen.eventBus.fire(UpdateEventPreference(
        bookmarked: bookmarked, preference: action, id: event.id!));
  }

  launchSms() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: event.contact!.phone,
    );
    await launchUrl(launchUri);
  }

  launchPhone() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: event.contact!.phone,
    );
    await launchUrl(launchUri);
  }

  launchWhatsapp() async {
    var whatsapp = event.contact!.whatsapp ?? ""; //+92xx enter like this
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(
          whatsappURLIos,
        ));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Whatsapp not installed")));
        }
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Whatsapp not installed")));
        }
      }
    }
  }

  launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: event.contact!.email,
      queryParameters: {
        'subject': '',
        'body': '',
      },
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      print('Could not launch $emailLaunchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _saveEventPrefs();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: ColorStyle.whiteColor,
            foregroundColor: ColorStyle.secondaryTextColor,
            elevation: 0.5,
            title: const Text("Details"),
            leading: IconButton(
              onPressed: () {
                _saveEventPrefs();
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ColorStyle.secondaryTextColor,
              ),
            ),
            actions: [
              PrefUtils().getIsAppTypeCustomer
                  ? Visibility(
                      visible: !event.myEvent!,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (bookmarked != null) {
                              bookmarked = !bookmarked!;
                            } else {
                              bookmarked = true;
                            }
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: ColorStyle.primaryColor.withOpacity(0.60),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                              (bookmarked ?? false)
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              color: ColorStyle.accentColor,
                              size: 18),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                          onPressed: () {
                            _openOptionsSheet();
                          },
                          icon: const Icon(Icons.menu)),
                    ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Visibility(
                        visible: (event.myEvent ?? false) &&
                            event.approvedOn == null,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: ColorStyle.primaryColorExtraLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: ColorStyle.primaryColor),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.warning_amber_outlined,
                                  color: ColorStyle.primaryColor, size: 18),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  "This event is still under-going our approval process and you'll recieve a response from us soon",
                                  style: TextStyle(
                                      color: ColorStyle.primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.maxFinite,
                        height: 160,
                        child: PageView.builder(
                            controller: _pageController,
                            itemCount: event.images!.length,
                            onPageChanged: (value) {
                              setState(() {
                                currentPage = value;
                              });
                            },
                            clipBehavior: Clip.antiAlias,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: SizedBox(
                                  width: double.maxFinite,
                                  height: 160,
                                  child: CachedNetworkImage(
                                      imageUrl: event.images?[index] ?? "",
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
                              );
                            }),
                      ),
                      // Container(
                      //   width: double.maxFinite,
                      //   height: 160,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(16),
                      //       image: const DecorationImage(
                      //           image: AssetImage(
                      //               "assets/pngs/example_card_image.png"),
                      //           fit: BoxFit.cover)),
                      // ),

                      Visibility(
                          visible:
                              event.images != null && event.images!.length >= 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: _buildPagerDotIndicator(),
                          )),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.name ?? "",
                              maxLines: null,
                              style: const TextStyle(
                                  color: ColorStyle.blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          _buildSellerCard()
                        ],
                      ),
                      const SizedBox(height: 15),
                      (event.myEvent ?? false)
                          ? SizedBox(
                              height: 200,
                              width: double.maxFinite,
                              child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 1.9,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  Container(
                                    width: double.maxFinite,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15, left: 10),
                                    decoration: BoxDecoration(
                                        color: ColorStyle.accentColor,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 4),
                                              blurRadius: 4,
                                              color: ColorStyle.blackColor
                                                  .withOpacity(0.25))
                                        ]),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.visibility_outlined,
                                          color: ColorStyle.primaryColor,
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              (event.stats?.viewed ?? 0)
                                                  .toString(),
                                              style: const TextStyle(
                                                  color:
                                                      ColorStyle.primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              " people viewed",
                                              style: TextStyle(
                                                  color:
                                                      ColorStyle.primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15, left: 10),
                                    decoration: BoxDecoration(
                                        color: ColorStyle.accentColor,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 4),
                                              blurRadius: 4,
                                              color: ColorStyle.blackColor
                                                  .withOpacity(0.25))
                                        ]),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.bookmark_add_outlined,
                                          color: ColorStyle.primaryColor,
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              (event.stats?.bookmarked ?? 0)
                                                  .toString(),
                                              style: const TextStyle(
                                                  color:
                                                      ColorStyle.primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              " people saved",
                                              style: TextStyle(
                                                  color:
                                                      ColorStyle.primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15, left: 10),
                                    decoration: BoxDecoration(
                                        color: ColorStyle.accentColor,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 4),
                                              blurRadius: 4,
                                              color: ColorStyle.blackColor
                                                  .withOpacity(0.25))
                                        ]),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.lightbulb_circle_outlined,
                                          color: ColorStyle.primaryColor,
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              (event.stats?.interested ?? 0)
                                                  .toString(),
                                              style: const TextStyle(
                                                  color:
                                                      ColorStyle.primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              " are interested",
                                              style: TextStyle(
                                                  color:
                                                      ColorStyle.primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15, left: 10),
                                    decoration: BoxDecoration(
                                        color: ColorStyle.accentColor,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 4),
                                              blurRadius: 4,
                                              color: ColorStyle.blackColor
                                                  .withOpacity(0.25))
                                        ]),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.done_all_outlined,
                                          color: ColorStyle.primaryColor,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              (event.stats?.going ?? 0)
                                                  .toString(),
                                              style: const TextStyle(
                                                  color:
                                                      ColorStyle.primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              " are coming",
                                              style: TextStyle(
                                                  color:
                                                      ColorStyle.primaryColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ))
                          : Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: ColorStyle.primaryTextColor),
                              child: Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      action = "interested";
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: Theme(
                                          data: ThemeData(
                                            unselectedWidgetColor:
                                                ColorStyle.secondaryTextColor,
                                          ),
                                          child: Transform.scale(
                                            scale: 0.9,
                                            child: Radio(
                                                value: "interested",
                                                splashRadius: 0,
                                                fillColor:
                                                    const MaterialStatePropertyAll(
                                                        ColorStyle.whiteColor),
                                                groupValue: action,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    action = newValue;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "I am interested in this event",
                                        style: TextStyle(
                                            color: ColorStyle.whiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      action = "going";
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: Theme(
                                          data: ThemeData(
                                            unselectedWidgetColor:
                                                ColorStyle.secondaryTextColor,
                                          ),
                                          child: Transform.scale(
                                            scale: 0.9,
                                            child: Radio(
                                                value: "going",
                                                splashRadius: 0,
                                                fillColor:
                                                    const MaterialStatePropertyAll(
                                                        ColorStyle.whiteColor),
                                                groupValue: action,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    action = newValue;
                                                  });
                                                }),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "I am going to this event",
                                        style: TextStyle(
                                            color: ColorStyle.whiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                            ),
                      const SizedBox(height: 20),
                      const Text(
                        "Contact",
                        style: TextStyle(
                            color: ColorStyle.secondaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Container(
                          // height: 45,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                              color: ColorStyle.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 4,
                                    color:
                                        ColorStyle.blackColor.withOpacity(0.25))
                              ]),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.contact?.name ?? "",
                                    style: const TextStyle(
                                      color: ColorStyle.primaryTextColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Text(
                                    "Ad lister",
                                    style: TextStyle(
                                      color: ColorStyle.secondaryTextColor,
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              Wrap(
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.center,
                                runSpacing: 10,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      await launchEmail();
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color:
                                              ColorStyle.primaryColorExtraLight,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: const Icon(Icons.email_outlined,
                                          color: ColorStyle.primaryColor,
                                          size: 16),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await launchSms();
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color:
                                              ColorStyle.primaryColorExtraLight,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: const Icon(Icons.chat_outlined,
                                          color: ColorStyle.primaryColor,
                                          size: 16),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      launchWhatsapp();
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color:
                                              ColorStyle.primaryColorExtraLight,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Image.asset(
                                        "assets/pngs/ic_whatsapp.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await launchPhone();
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color:
                                              ColorStyle.primaryColorExtraLight,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: const Icon(Icons.call_outlined,
                                          color: ColorStyle.primaryColor,
                                          size: 16),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      const SizedBox(height: 30),
                      const Text(
                        "Details",
                        style: TextStyle(
                            color: ColorStyle.secondaryTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  //height: 45,
                                  // width: 160,
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10),
                                  decoration: BoxDecoration(
                                      color: ColorStyle.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 4),
                                            blurRadius: 4,
                                            color: ColorStyle.blackColor
                                                .withOpacity(0.25))
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.today_outlined,
                                              color:
                                                  ColorStyle.primaryColorLight,
                                              size: 20),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            DateFormat('MMM d, y').format(
                                                DateTime.parse(
                                                    event.dateTime!)),
                                            style: const TextStyle(
                                                color:
                                                    ColorStyle.primaryTextColor,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.schedule,
                                              color:
                                                  ColorStyle.primaryColorLight,
                                              size: 20),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            DateFormat('h:mm a').format(
                                                DateTime.parse(
                                                    event.dateTime!)),
                                            style: const TextStyle(
                                              color:
                                                  ColorStyle.primaryTextColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Container(
                                  // width: 160,
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10),
                                  decoration: BoxDecoration(
                                      color: ColorStyle.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 4),
                                            blurRadius: 4,
                                            color: ColorStyle.blackColor
                                                .withOpacity(0.25))
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.sell_outlined,
                                              color:
                                                  ColorStyle.primaryColorLight,
                                              size: 20),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Starts from ${event.priceStartsFrom ?? 0}",
                                            style: const TextStyle(
                                                color:
                                                    ColorStyle.primaryTextColor,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svgs/ic_double_sell.svg",
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Goes up to ${event.priceGoesUpto ?? 0}",
                                            style: const TextStyle(
                                              color:
                                                  ColorStyle.primaryTextColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _openBottomSheet(
                                        context,
                                        PassDetailsSheet(
                                            passDetails: event.passes ?? []));
                                  },
                                  child: Container(
                                    //height: 45,
                                    // width: 160,
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15, left: 10),
                                    decoration: BoxDecoration(
                                        color: ColorStyle.whiteColor,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 4),
                                              blurRadius: 4,
                                              color: ColorStyle.blackColor
                                                  .withOpacity(0.25))
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.groups_outlined,
                                                color: ColorStyle
                                                    .primaryColorLight,
                                                size: 20),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "${event.maxCapacity} Max Capacity",
                                                style: const TextStyle(
                                                    color: ColorStyle
                                                        .primaryTextColor,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.badge_outlined,
                                                color: ColorStyle
                                                    .primaryColorLight,
                                                size: 20),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "View Passes",
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: ColorStyle
                                                      .primaryColorLight,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _openBottomSheet(
                                        context,
                                        LocationDetailSheet(
                                          lat: event.latitude ?? 0.0,
                                          lng: event.longitude ?? 0.0,
                                          address: event.address ?? "",
                                        ));
                                  },
                                  child: Container(
                                    width: 160,
                                    constraints:
                                        const BoxConstraints(minHeight: 85),
                                    padding: const EdgeInsets.only(
                                        top: 15,
                                        bottom: 15,
                                        left: 10,
                                        right: 10),
                                    decoration: BoxDecoration(
                                      color: ColorStyle.whiteColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 4),
                                          blurRadius: 4,
                                          color: ColorStyle.blackColor
                                              .withOpacity(0.25),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                                Icons.location_on_outlined,
                                                color: ColorStyle
                                                    .primaryColorLight,
                                                size: 20),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                event.address ?? "",
                                                style: const TextStyle(
                                                    color: ColorStyle
                                                        .primaryTextColor,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.redo,
                                                color: ColorStyle
                                                    .primaryColorLight,
                                                size: 20),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "View Location",
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: ColorStyle
                                                      .primaryColorLight,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            "Description",
                            style: TextStyle(
                                color: ColorStyle.secondaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 15, left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: ColorStyle.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      ColorStyle.blackColor.withOpacity(0.25),
                                ),
                              ],
                            ),
                            child: Text(
                              event.description ?? "",
                              style: const TextStyle(
                                color: ColorStyle.primaryTextColor,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Visibility(
              //   visible: !PrefUtils().getIsUserLoggedIn,
              //   child: Positioned.fill(
              //     child: Container(
              //       decoration: BoxDecoration(
              //           color: ColorStyle.whiteColor.withOpacity(0.1)),
              //       child: BackdropFilter(
              //         filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              //         child: Container(
              //           color: Colors.white.withOpacity(0.1),
              //           child: Center(
              //             child: Container(
              //                 // height: 200,
              //                 margin: const EdgeInsets.only(
              //                     top: 15, bottom: 15, left: 25, right: 25),
              //                 padding: const EdgeInsets.only(
              //                     top: 30, bottom: 30, left: 25, right: 25),
              //                 decoration: BoxDecoration(
              //                     color: ColorStyle.whiteColor,
              //                     borderRadius: BorderRadius.circular(12),
              //                     boxShadow: [
              //                       BoxShadow(
              //                           offset: const Offset(0, 4),
              //                           blurRadius: 4,
              //                           color: ColorStyle.blackColor
              //                               .withOpacity(0.25))
              //                     ]),
              //                 child: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     GestureDetector(
              //                       onTap: () {
              //                         Navigator.of(context).pushNamed(
              //                             signupRoute,
              //                             arguments: SignupArgs(true, false));
              //                       },
              //                       child: RichText(
              //                         text: const TextSpan(
              //                             style: TextStyle(
              //                                 color:
              //                                     ColorStyle.primaryTextColor,
              //                                 fontSize: 28,
              //                                 fontWeight: FontWeight.bold),
              //                             text: "You’ll need to ",
              //                             children: [
              //                               TextSpan(
              //                                 text: "sign in",
              //                                 style: TextStyle(
              //                                     color:
              //                                         ColorStyle.primaryColor,
              //                                     decoration:
              //                                         TextDecoration.underline),
              //                               ),
              //                               TextSpan(
              //                                 text: " to access this page",
              //                               ),
              //                             ]),
              //                       ),
              //                     ),
              //                     const SizedBox(height: 20),
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.start,
              //                       children: [
              //                         Container(
              //                           height: 1,
              //                           width: 50,
              //                           color: ColorStyle.secondaryTextColor,
              //                         ),
              //                         const SizedBox(width: 5),
              //                         const Text(
              //                           'or',
              //                           style: TextStyle(
              //                               color:
              //                                   ColorStyle.secondaryTextColor,
              //                               fontSize: 10),
              //                         ),
              //                         const SizedBox(width: 5),
              //                         Container(
              //                           height: 1,
              //                           width: 50,
              //                           color: ColorStyle.secondaryTextColor,
              //                         ),
              //                       ],
              //                     ),
              //                     const SizedBox(height: 20),
              //                     GestureDetector(
              //                       onTap: () {
              //                         Navigator.of(context).pushNamed(
              //                             signupRoute,
              //                             arguments: SignupArgs(true, true));
              //                       },
              //                       child: const Text("Create a free account",
              //                           style: TextStyle(
              //                               color: ColorStyle.primaryColor,
              //                               fontSize: 18,
              //                               decoration:
              //                                   TextDecoration.underline)),
              //                     )
              //                   ],
              //                 )),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          )),
    );
  }

  Widget _buildPagerDotIndicator() {
    List<Widget> dotsWidget = [];
    for (int i = 0; i < event.images!.length; i++) {
      dotsWidget.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 1.0),
        width: 6,
        height: 6,
        decoration: BoxDecoration(
            color: i == currentPage
                ? ColorStyle.primaryColor
                : ColorStyle.secondaryTextColor,
            shape: BoxShape.circle),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dotsWidget,
    );
  }

  _buildSellerCard() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border:
              Border.all(color: ColorStyle.primaryTextColor.withOpacity(0.68)),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.assignment_ind_outlined,
              color: ColorStyle.primaryTextColor, size: 18),
          const SizedBox(
            width: 3,
          ),
          Text(
            event.contact?.name ?? "",
            style: const TextStyle(
                color: ColorStyle.primaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _openBottomSheet(BuildContext context, Widget sheet) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => sheet,
    );
  }

  _openOptionsSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CupertinoActionSheet(
                actions: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(createEventRoute,
                          arguments: CreateEventsArgs(event: event));
                    },
                    child: Container(
                        height: 60,
                        color: Colors.white,
                        child: const Center(
                          child: Text("Edit Information",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorStyle.primaryTextColor)),
                        )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      _editVisibility();
                    },
                    child: Container(
                        height: 60,
                        color: Colors.white,
                        child: Container(
                          // margin: const EdgeInsets.only(left: 25),
                          child: Center(
                            child: Text(
                                (event.listingVisible ?? false)
                                    ? "Disable Visibility"
                                    : "Enable Visibility",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorStyle.primaryTextColor)),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      _showDeleteConfirmationDialog();
                    },
                    child: Container(
                        height: 60,
                        color: Colors.white,
                        child: Container(
                          // margin: const EdgeInsets.only(left: 25),
                          child: const Center(
                            child: Text("Delete Listing",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorStyle.primaryTextColor)),
                          ),
                        )),
                  ),
                ],
                cancelButton: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: ColorStyle.primaryColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Text("Cancel",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorStyle.whiteColor)),
                        ))),
              ),
            ));
  }

  _editVisibility() {
    try {
      SmartDialog.showLoading(
          builder: (_) =>
              const LoadingUtil(type: 4, text: "Updating your event..."));

      EventService()
          .toggleListing(event.id!, !event.listingVisible!)
          .then((value) {
        SmartDialog.dismiss();
        if (value.snapshot != null) {
          EventResponse apiResponse = value.snapshot;
          if (apiResponse.success ?? false) {
            SellerHomeScreen.eventBus.fire(RefreshMyEvents());
            setState(() {
              event = apiResponse.data!.event!;
            });
            ToastUtils.showCustomSnackbar(
              context: context,
              millisecond: 5000,
              icon: const Icon(
                Icons.celebration_outlined,
                color: ColorStyle.whiteColor,
              ),
              contentText:
                  "Congratulations! Your event has been updated successfully",
            );
            Future.delayed(const Duration(milliseconds: 2000)).then((value) {});
          } else {
            ToastUtils.showCustomSnackbar(
                context: context, contentText: apiResponse.message ?? "");
          }
        } else {
          ToastUtils.showCustomSnackbar(
              context: context, contentText: value.error ?? "");
        }
      });
    } catch (e) {
      ToastUtils.showCustomSnackbar(
          context: context, contentText: e.toString());
    }
  }

  _showDeleteConfirmationDialog() {
    Dialog dialog = Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(
                  child: Text(
                    "Delete Event?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ColorStyle.primaryTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Do you want to permanently delete this event from the platform? You can disable the listing if you want to turn off visibility for the public",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 40,
                              child: CustomRoundedButton(
                                "Later",
                                () {
                                  Navigator.of(context).pop();
                                },
                                borderColor: ColorStyle.greyColor,
                                buttonBackgroundColor: ColorStyle.greyColor,
                                textColor: ColorStyle.secondaryTextColor,
                                textSize: 14,
                                roundedCorners: 4,
                                textWeight: FontWeight.w600,
                              ))),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: SizedBox(
                              height: 40,
                              child: CustomRoundedButton(
                                "Delete",
                                () {
                                  Navigator.of(context).pop();
                                  _deleteEvent();
                                },
                                textSize: 14,
                                roundedCorners: 4,
                                textWeight: FontWeight.w600,
                              ))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) => dialog,
        barrierColor: const Color(0x59000000));
  }

  _deleteEvent() async {
    try {
      SmartDialog.showLoading(
          builder: (_) => const LoadingUtil(
                type: 4,
                text: "Deleting your event...",
              ));
      EventService().deleteEvent(event.id!).then((value) {
        SmartDialog.dismiss();
        if (value.snapshot != null) {
          GenericResponse apiResponse = value.snapshot;
          if (apiResponse.success ?? false) {
            ToastUtils.showCustomSnackbar(
              context: context,
              millisecond: 5000,
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: ColorStyle.whiteColor,
              ),
              contentText: "Event permanently deleted",
            );
            Future.delayed(const Duration(milliseconds: 1000)).then((value) {
              SellerHomeScreen.eventBus.fire(RefreshDiscoverEvents());
              Navigator.of(context).pop();
            });
          } else {
            ToastUtils.showCustomSnackbar(
                context: context, contentText: apiResponse.message ?? "");
          }
        } else {
          ToastUtils.showCustomSnackbar(
              context: context, contentText: value.error ?? "");
        }
      });
    } catch (e) {
      ToastUtils.showCustomSnackbar(
          context: context, contentText: e.toString());
    }
  }
}
