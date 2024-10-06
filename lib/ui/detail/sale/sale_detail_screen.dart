import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/models/api_models/sale_response/sale.dart';
import 'package:eventify/models/api_models/sale_response/sale_response.dart';
import 'package:eventify/models/event_bus/refresh_discover_event.dart';
import 'package:eventify/models/event_bus/refresh_my_events.dart';
import 'package:eventify/models/event_bus/update_stats_event.dart';
import 'package:eventify/models/screen_args/create_sale_args.dart';
import 'package:eventify/services/sale_service.dart';
import 'package:eventify/services/stats_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/seller/base/base_seller_screen.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/bottom_sheets/user_contact_list_sheet.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SaleDetailScreen extends StatefulWidget {
  final CreateSaleArgs args;
  const SaleDetailScreen({super.key, required this.args});

  @override
  State<SaleDetailScreen> createState() => _SaleDetailScreenState();
}

class _SaleDetailScreenState extends State<SaleDetailScreen>
    with WidgetsBindingObserver {
  final QuillController _controller = QuillController.basic();
  String? action;
  bool? bookmarked;
  late Sale sale;
  final PageController _pageController =
      PageController(viewportFraction: 1, keepPage: true);
  int currentPage = 0;
  StatsService statsService = StatsService();
  bool plainTextView = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    sale = widget.args.sale!;
    if (sale.preference != null) {
      action = sale.preference!.preference;
      bookmarked = sale.preference!.bookmarked;
    }
    // final jsonDescription = json.decode(event.description ?? "");
    // _controller.document = Document.fromJson(jsonDescription);
    _initializeDocument();
    // BaseSellerScreen.eventBus.on<UpdateStatsEvent>().listen((ev) {
    //   // event.stats = ev.stats;
    //   setState(() {});
    // });
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _initializeDocument() {
    try {
      final jsonDescription = json.decode(sale.description ?? "");
      _controller.document = Document.fromJson(jsonDescription);
    } catch (e) {
      plainTextView = true;
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   if (state == AppLifecycleState.inactive ||
  //       state == AppLifecycleState.detached) return;
  //   final isBackgrond = state == AppLifecycleState.paused;
  //   if (isBackgrond) {
  //     _saveEventPrefs();
  //   }
  // }

  // _saveEventPrefs() async {
  //   if (event.myEvent ?? false) {
  //     return;
  //   }
  //   StatsService().updateStats(action, bookmarked, event.id!);
  //   SavedScreen.eventBus.fire(UpdateStatsEvent(
  //     id: event.id!,
  //     bookmarked: bookmarked,
  //   ));
  //   DiscoverScreen.eventBus.fire(UpdateStatsEvent(
  //     id: event.id!,
  //     bookmarked: bookmarked,
  //   ));
  //   // AlertsScreen.eventBus.fire(UpdateStatsEvent(
  //   //   id: event.id!,
  //   //   bookmarked: bookmarked,
  //   // ));
  // }

  launchSms() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: sale.contact!.phone,
    );
    await launchUrl(launchUri);
  }

  launchPhone() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: sale.contact!.phone,
    );
    await launchUrl(launchUri);
  }

  launchWhatsapp() async {
    var whatsapp = sale.contact!.whatsapp ?? ""; //+92xx enter like this
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
      path: sale.contact!.email,
      queryParameters: {
        'subject': '',
        'body': '',
      },
    );

    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    } else {
      //print('Could not launch $emailLaunchUri');
    }
  }

  _buildPriceCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: ColorStyle.primaryColor.withOpacity(0.70),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sell_outlined,
              color: ColorStyle.accentColor, size: 14),
          const SizedBox(
            width: 3,
          ),
          Text(
            sale.discountDescription ?? "",
            style: const TextStyle(
                color: ColorStyle.accentColor,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorStyle.whiteColor,
          foregroundColor: ColorStyle.secondaryTextColor,
          elevation: 0.5,
          title: const Text("Details"),
          leading: IconButton(
            onPressed: () {
              // _saveEventPrefs();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: ColorStyle.secondaryTextColor,
            ),
          ),
          actions: [
            Padding(
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
                      visible:
                          (sale.myEvent ?? false) && sale.approvedOn == null,
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
                                "This sale listing is still under-going our approval process and you'll recieve a response from us soon",
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
                          itemCount: sale.images!.length,
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
                                    imageUrl: sale.images?[index] ?? "",
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
                            sale.images != null && sale.images!.length >= 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: _buildPagerDotIndicator(),
                        )),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sale.name ?? "",
                                maxLines: null,
                                style: const TextStyle(
                                    color: ColorStyle.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              _buildSellerCard(),
                            ],
                          ),
                        ),
                        _buildPriceCard()
                      ],
                    ),

                    const SizedBox(height: 15),
                    (sale.myEvent ?? false) &&
                            PrefUtils().getIsAppTypeCustomer == false
                        ? Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 10),
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 15, left: 10),
                                      decoration: BoxDecoration(
                                          color: ColorStyle.accentColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 4),
                                                blurRadius: 4,
                                                color: ColorStyle.blackColor
                                                    .withOpacity(0.25))
                                          ]),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                (sale.stats?.viewed ?? 0)
                                                    .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        ColorStyle.primaryColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const Text(
                                                " people viewed this listing",
                                                style: TextStyle(
                                                    color:
                                                        ColorStyle.primaryColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          )
                        : AbsorbPointer(
                            absorbing: (sale.myEvent ?? false),
                            child: Opacity(
                              opacity: (sale.myEvent ?? false) ? 0.4 : 1,
                              child: Container(
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
                                                          ColorStyle
                                                              .whiteColor),
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
                                                          ColorStyle
                                                              .whiteColor),
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
                            ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${sale.contact?.name ?? ""} - Ad Lister",
                              style: const TextStyle(
                                color: ColorStyle.primaryTextColor,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await launchEmail();
                                    },
                                    child: Container(
                                      // width: 35,
                                      height: 40,
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
                                          size: 20),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await launchSms();
                                    },
                                    child: Container(
                                      // width: 35,
                                      height: 40,
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
                                          size: 20),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      launchWhatsapp();
                                    },
                                    child: Container(
                                      // width: 35,
                                      height: 40,
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
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      await launchPhone();
                                    },
                                    child: Container(
                                      // width: 35,
                                      height: 40,
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
                                          size: 20),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 85,
                                width: double.maxFinite,
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
                                child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Online Store",
                                        style: TextStyle(
                                            color: ColorStyle.primaryTextColor,
                                            fontSize: 12),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.shopping_bag_outlined,
                                              color:
                                                  ColorStyle.primaryColorLight,
                                              size: 20),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "View Store",
                                            style: TextStyle(
                                              color: ColorStyle.primaryColor,
                                              fontSize: 13,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  ColorStyle.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                            if (sale.website != null &&
                                sale.website != "" &&
                                sale.linkToStores != null &&
                                sale.linkToStores != "")
                              SizedBox(width: 20),
                            Expanded(
                              child: Container(
                                height: 85,
                                width: double.maxFinite,
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
                                child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Store Locations",
                                        style: TextStyle(
                                            color: ColorStyle.primaryTextColor,
                                            fontSize: 12),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.pin_drop_outlined,
                                              color:
                                                  ColorStyle.primaryColorLight,
                                              size: 20),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "View Locations",
                                            style: TextStyle(
                                              color: ColorStyle.primaryColor,
                                              fontSize: 13,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  ColorStyle.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Starts",
                                style: TextStyle(
                                    color: ColorStyle.secondaryTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 85,
                                width: double.maxFinite,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.today_outlined,
                                            color: ColorStyle.primaryColorLight,
                                            size: 20),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          DateFormat('MMM d, y').format(
                                              DateTime.parse(
                                                  sale.startDateTime!)),
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
                                            color: ColorStyle.primaryColorLight,
                                            size: 20),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          DateFormat('h:mm a').format(
                                              DateTime.parse(
                                                  sale.startDateTime!)),
                                          style: const TextStyle(
                                            color: ColorStyle.primaryTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Ends",
                                style: TextStyle(
                                    color: ColorStyle.secondaryTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                height: 85,
                                width: double.maxFinite,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.today_outlined,
                                            color: ColorStyle.primaryColorLight,
                                            size: 20),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          DateFormat('MMM d, y').format(
                                              DateTime.parse(
                                                  sale.endDateTime!)),
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
                                            color: ColorStyle.primaryColorLight,
                                            size: 20),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          DateFormat('h:mm a').format(
                                              DateTime.parse(
                                                  sale.endDateTime!)),
                                          style: const TextStyle(
                                            color: ColorStyle.primaryTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
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
                                color: ColorStyle.blackColor.withOpacity(0.25),
                              ),
                            ],
                          ),
                          child: plainTextView
                              ? Text(
                                  sale.description ?? "",
                                  style: const TextStyle(
                                    color: ColorStyle.primaryTextColor,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                )
                              : QuillEditor.basic(
                                  configurations: QuillEditorConfigurations(
                                      controller: _controller,
                                      readOnly: true,
                                      showCursor: false),
                                ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildPagerDotIndicator() {
    List<Widget> dotsWidget = [];
    for (int i = 0; i < sale.images!.length; i++) {
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
            sale.contact?.name ?? "",
            style: const TextStyle(
                color: ColorStyle.primaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _openContactsBottomSheet(BuildContext context, String filter) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => UserContactListSheet(
        filter: filter,
        eventId: sale.id!,
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
                      Navigator.of(context).pushNamed(createSaleRoute,
                          arguments: CreateSaleArgs(sale: sale));
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
                        child: Center(
                          child: Text(
                              (sale.listingVisibile ?? false)
                                  ? "Disable Visibility"
                                  : "Enable Visibility",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorStyle.primaryTextColor)),
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
                        child: const Center(
                          child: Text("Delete Listing",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorStyle.primaryTextColor)),
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
                    ),
                  ),
                ),
              ),
            ));
  }

  _editVisibility() {
    try {
      SmartDialog.showLoading(
          builder: (_) =>
              const LoadingUtil(type: 4, text: "Updating your event..."));

      SaleService()
          .toggleListing(sale.id!, !sale.listingVisibile!)
          .then((value) {
        SmartDialog.dismiss();
        if (value.snapshot != null) {
          SaleResponse apiResponse = value.snapshot;
          if (apiResponse.success ?? false) {
            BaseSellerScreen.eventBus.fire(RefreshMyEvents());

            setState(() {
              sale = apiResponse.data!.sale!;
            });
            ToastUtils.showCustomSnackbar(
              context: context,
              millisecond: 5000,
              icon: const Icon(
                Icons.celebration_outlined,
                color: ColorStyle.whiteColor,
              ),
              contentText:
                  "Congratulations! Your sale has been updated successfully",
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
                    "Delete Sale?",
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
                  "Do you want to permanently delete this listing from the platform? You can disable the listing if you want to turn off visibility for the public",
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
                text: "Deleting your sale...",
              ));
      SaleService().deleteSale(sale.id!).then((value) {
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
              contentText: "Sale permanently deleted",
            );
            Future.delayed(const Duration(milliseconds: 1000)).then((value) {
              BaseSellerScreen.eventBus.fire(RefreshDiscoverEvents());
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
