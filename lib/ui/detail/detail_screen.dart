import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/event_list_response/event.dart';
import 'package:eventify/models/api_models/event_list_response/pass_detail.dart';
import 'package:eventify/models/screen_args/create_event_args.dart';
import 'package:eventify/models/screen_args/detail_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/widgets/bottom_sheets/location_detail_sheet.dart';
import 'package:eventify/widgets/bottom_sheets/pass_details_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final DetailArgs args;
  const DetailScreen({super.key, required this.args});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? action;
  late Event event;
  final PageController _pageController =
      PageController(viewportFraction: 1, keepPage: true);
  int currentPage = 0;

  @override
  initState() {
    super.initState();
    event = widget.args.event;
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!.toInt();
      });
    });
  }

  launchSms() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: event.contactPhoneNumber,
    );
    await launchUrl(launchUri);
  }

  launchPhone() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: event.contactPhoneNumber,
    );
    await launchUrl(launchUri);
  }

  launchWhatsapp() async {
    var whatsapp = event.contactWhatsApp ?? ""; //+92xx enter like this
    var whatsappURlAndroid = "whatsapp://send?phone=" + whatsapp + "&text=";
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
    // Email address you want to send the email to
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: event.contactEmail, // Replace with the recipient's email
      queryParameters: {
        'subject': 'Subject of the email',
        'body': 'Body of the email',
      },
    );

    // Check if the device can open the specified URL
    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      print('Could not launch $_emailLaunchUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorStyle.whiteColor,
          foregroundColor: ColorStyle.secondaryTextColor,
          elevation: 0.5,
          title: const Text("Details"),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: ColorStyle.secondaryTextColor,
            ),
          ),
          actions: [
            PrefUtils().getIsAppTypeCustomer
                ? Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: ColorStyle.primaryColor.withOpacity(0.60),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bookmark_outline,
                        color: ColorStyle.accentColor, size: 18),
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
                    SizedBox(
                      width: double.maxFinite,
                      height: 160,
                      child: PageView.builder(
                          controller: _pageController,
                          itemCount: event.eventImages!.length,
                          clipBehavior: Clip.antiAlias,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                width: double.maxFinite,
                                height: 160,
                                child: CachedNetworkImage(
                                    imageUrl:
                                        event.eventImages?[index].imagePath ??
                                            "",
                                    errorWidget: (context, url, error) {
                                      return Container(
                                        color: ColorStyle.secondaryTextColor,
                                        child: Center(
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
                        visible: event.eventImages != null &&
                            event.eventImages!.length >= 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: _buildPagerDotIndicator(),
                        )),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.eventName ?? "",
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
                    Container(
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
                            // ClipRRect(
                            //     borderRadius: BorderRadius.circular(200.0),
                            //     child: SizedBox(
                            //         height: 50,
                            //         width: 50,
                            //         child: Image.asset(
                            //           "assets/pngs/image_placeholder.png",
                            //           fit: BoxFit.contain,
                            //         ))),
                            // const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.contactPersonName ?? "",
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
                                        borderRadius: BorderRadius.circular(8)),
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
                                        borderRadius: BorderRadius.circular(8)),
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
                                        borderRadius: BorderRadius.circular(8)),
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
                                        borderRadius: BorderRadius.circular(8)),
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
                                          event.eventDate ?? "",
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
                                          event.eventTime ?? "",
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
                            ),
                            SizedBox(width: 20),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.sell_outlined,
                                            color: ColorStyle.primaryColorLight,
                                            size: 20),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Starts from ${event.priceStartFrom ?? 0}",
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
                                            color: ColorStyle.primaryTextColor,
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
                                          passDetails:
                                              event.eventPassDetails ?? []));
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.groups_outlined,
                                              color:
                                                  ColorStyle.primaryColorLight,
                                              size: 20),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${event.capacity} Max Capacity",
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
                                              color:
                                                  ColorStyle.primaryColorLight,
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
                            SizedBox(width: 20),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _openBottomSheet(
                                      context,
                                      LocationDetailSheet(
                                        lat: event.latitude ?? 0,
                                        lng: event.longitude ?? 0,
                                        address: event.address ?? "",
                                      ));
                                },
                                child: Container(
                                  width: 160,
                                  constraints:
                                      const BoxConstraints(minHeight: 85),
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10, right: 10),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.location_on_outlined,
                                              color:
                                                  ColorStyle.primaryColorLight,
                                              size: 20),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              event.address ?? "",
                                              style: TextStyle(
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
                                              color:
                                                  ColorStyle.primaryColorLight,
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
                            )
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
                                        ColorStyle.blackColor.withOpacity(0.25))
                              ]),
                          child: Text(
                            event.eventDescription ?? "",
                            style: const TextStyle(
                              color: ColorStyle.primaryTextColor,
                              fontSize: 12,
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
            Visibility(
              visible: !PrefUtils().getIsUserLoggedIn,
              child: Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorStyle.whiteColor.withOpacity(0.1)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      color: Colors.white
                          .withOpacity(0.1), // Adjust opacity as needed
                      child: Center(
                        child: Container(
                            // height: 200,
                            margin: const EdgeInsets.only(
                                top: 15, bottom: 15, left: 25, right: 25),
                            padding: const EdgeInsets.only(
                                top: 30, bottom: 30, left: 25, right: 25),
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
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(signupRoute,
                                        arguments: SignupArgs(true, false));
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                        style: TextStyle(
                                            color: ColorStyle.primaryTextColor,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold),
                                        text: "You’ll need to ",
                                        children: [
                                          TextSpan(
                                            text: "sign in",
                                            style: TextStyle(
                                                color: ColorStyle.primaryColor,
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                          TextSpan(
                                            text: " to access this page",
                                          ),
                                        ]),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 1,
                                      width: 50,
                                      color: ColorStyle.secondaryTextColor,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'or',
                                      style: TextStyle(
                                          color: ColorStyle.secondaryTextColor,
                                          fontSize: 10),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      height: 1,
                                      width: 50,
                                      color: ColorStyle.secondaryTextColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(signupRoute,
                                        arguments: SignupArgs(true, true));
                                  },
                                  child: const Text("Create a free account",
                                      style: TextStyle(
                                          color: ColorStyle.primaryColor,
                                          fontSize: 18,
                                          decoration:
                                              TextDecoration.underline)),
                                )
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildPagerDotIndicator() {
    List<Widget> dotsWidget = [];
    for (int i = 0; i < event.eventImages!.length; i++) {
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
            event.organizeBy ?? "",
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

  _overlayContainer() {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
        // Add a background color or image to see the blur effect
        color: Colors.transparent,
        // Apply a blur effect using BackdropFilter
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: const Center(
          child: Text(
            'Blur',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
                      //await openImages();
                    },
                    child: Container(
                        height: 60,
                        color: Colors.white,
                        child: Container(
                          // margin: const EdgeInsets.only(left: 25),
                          child: const Center(
                            child: Text("Disable Visibility",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorStyle.primaryTextColor)),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      //await openImages();
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
}
