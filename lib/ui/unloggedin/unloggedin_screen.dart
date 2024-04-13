import 'dart:ui';

import 'package:animate_gradient/animate_gradient.dart';
import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';

class UnLoggedInScreen extends StatefulWidget {
  const UnLoggedInScreen({super.key});

  @override
  State<UnLoggedInScreen> createState() => _UnLoggedInScreenState();
}

class _UnLoggedInScreenState extends State<UnLoggedInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AnimateGradient(
          duration: Duration(seconds: 6),
          primaryBegin: Alignment.topRight,
          primaryEnd: Alignment.centerLeft,
          secondaryBegin: Alignment.centerLeft,
          secondaryEnd: Alignment.bottomLeft,
          primaryColors: const [
            ColorStyle.primaryColor,
            ColorStyle.primaryColorExtraLight,
            Colors.white,
          ],
          secondaryColors: const [
            ColorStyle.accentColor,
            ColorStyle.primaryColorExtraLight,
            ColorStyle.primaryColorLight,
          ],
        ),
        Positioned.fill(
          child: Container(
            decoration:
                BoxDecoration(color: ColorStyle.whiteColor.withOpacity(0.1)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
              child: Container(
                color: Colors.white.withOpacity(0.3),
                child: Center(
                  child: Container(
                      // height: 200,
                      margin: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 25, right: 25),
                      padding: const EdgeInsets.only(
                        top: 30,
                        bottom: 30,
                      ),
                      decoration: BoxDecoration(
                          color: ColorStyle.whiteColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                                color: ColorStyle.blackColor.withOpacity(0.25))
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 12, bottom: 12),
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.arrow_back,
                                color: ColorStyle.secondaryTextColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(signupRoute,
                                  arguments: SignupArgs(true, false));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
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
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
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
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(signupRoute,
                                  arguments: SignupArgs(true, true));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: const Text("Create a free account",
                                  style: TextStyle(
                                      color: ColorStyle.primaryColor,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline)),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          ),
        ),
      ]),
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
}
