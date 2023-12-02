import 'dart:io';
import 'dart:ui';

import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? action = null;

  launchSms() async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: '030000000',
    );
    await launchUrl(launchUri);
  }

  launchPhone() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '030000000',
    );
    await launchUrl(launchUri);
  }

  void launchWhatsapp() async {
    var whatsapp = "+9200000000"; //+92xx enter like this
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
                    Stack(
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/pngs/example_card_image.png"),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          width: double.maxFinite,
                          height: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    ColorStyle.blackColor.withOpacity(0),
                                    ColorStyle.blackColor
                                  ])),
                        ),
                        const Positioned(
                          bottom: 10,
                          left: 10,
                          child: Text(
                            "UN MUN 2023 Spring",
                            maxLines: null,
                            style: TextStyle(
                                color: ColorStyle.whiteColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
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
                            ClipRRect(
                                borderRadius: BorderRadius.circular(200.0),
                                child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                      "assets/pngs/image_placeholder.png",
                                      fit: BoxFit.contain,
                                    ))),
                            const SizedBox(width: 5),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Moasfar Javed",
                                  style: TextStyle(
                                    color: ColorStyle.primaryTextColor,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Ad lister",
                                  style: TextStyle(
                                    color: ColorStyle.secondaryTextColor,
                                    fontSize: 10,
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                await launchPhone();
                              },
                              child: Container(
                                width: 45,
                                height: 45,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: ColorStyle.primaryColorExtraLight,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.call_outlined,
                                    color: ColorStyle.primaryColor, size: 25),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await launchSms();
                              },
                              child: Container(
                                width: 45,
                                height: 45,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: ColorStyle.primaryColorExtraLight,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.chat_outlined,
                                    color: ColorStyle.primaryColor, size: 25),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchWhatsapp();
                              },
                              child: Container(
                                width: 45,
                                height: 45,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: ColorStyle.primaryColorExtraLight,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Image.asset(
                                  "assets/pngs/ic_whatsapp.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
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
                            Container(
                              //height: 45,
                              width: 160,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.today_outlined,
                                          color: ColorStyle.primaryColorLight,
                                          size: 20),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "22, Aug 2023",
                                        style: TextStyle(
                                            color: ColorStyle.primaryTextColor,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.schedule,
                                          color: ColorStyle.primaryColorLight,
                                          size: 20),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "9:30 PM",
                                        style: TextStyle(
                                          color: ColorStyle.primaryTextColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 160,
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
                                  const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.sell_outlined,
                                          color: ColorStyle.primaryColorLight,
                                          size: 20),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Starts from 200",
                                        style: TextStyle(
                                            color: ColorStyle.primaryTextColor,
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
                                      const Text(
                                        "Goes up to 2000",
                                        style: TextStyle(
                                          color: ColorStyle.primaryTextColor,
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
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              //height: 45,
                              width: 160,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.groups_outlined,
                                          color: ColorStyle.primaryColorLight,
                                          size: 20),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "200 Max Capacity",
                                          style: TextStyle(
                                              color:
                                                  ColorStyle.primaryTextColor,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.badge_outlined,
                                          color: ColorStyle.primaryColorLight,
                                          size: 20),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "30 Passes Left",
                                          style: TextStyle(
                                            color: ColorStyle.primaryTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 160,
                              constraints: const BoxConstraints(minHeight: 85),
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
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          color: ColorStyle.primaryColorLight,
                                          size: 20),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Port Grand Food St, West Wharf",
                                          style: TextStyle(
                                              color:
                                                  ColorStyle.primaryTextColor,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                          child: const Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam non tortor nec erat fermentum scelerisque vel suscipit risus. Integer lacinia justo a pharetra tristique. Nulla mollis feugiat magna, quis dictum orci feugiat id. Donec quis magna ut nunc sagittis sodales. Etiam convallis laoreet iaculis.",
                            style: TextStyle(
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
                      //await openImages();
                    },
                    child: Container(
                        height: 60,
                        color: Colors.white,
                        child: Container(
                          // margin: const EdgeInsets.only(left: 25),
                          child: const Center(
                            child: Text("Edit Information",
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
