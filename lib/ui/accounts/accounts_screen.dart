import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/splash_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  bool sellerMode = false;
  bool notificationAllowed = false;

  _switchApps() {
    setState(() {
      sellerMode = !sellerMode;
    });
    Future.delayed(const Duration(milliseconds: 300)).then(
      (value) {
        PrefUtils().setIsAppTypeCustomer = !PrefUtils().getIsAppTypeCustomer;

        Navigator.of(context).pushNamedAndRemoveUntil(
            initialRoute, (e) => false,
            arguments: SplashArgs(true));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.whiteColor,
        foregroundColor: ColorStyle.secondaryTextColor,
        elevation: 0.5,
        leading: PrefUtils().getIsAppTypeCustomer
            ? null
            : IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: ColorStyle.secondaryTextColor,
                ),
              ),
        title: const Text(
          "Account",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: Center(
                  child: Container(
                      height: 70,
                      width: 70,
                      child: Image.asset(
                        "assets/pngs/image_placeholder.png",
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Moasfar Javed",
                style: TextStyle(
                    color: ColorStyle.primaryTextColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _switchApps,
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 2,
                        color: ColorStyle.secondaryTextColor.withOpacity(0.2),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        !PrefUtils().getIsAppTypeCustomer
                            ? "Switch to buyer mode"
                            : "Switch to seller mode",
                        style: const TextStyle(
                            color: ColorStyle.primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      FlutterSwitch(
                          width: 40.0,
                          height: 20.0,
                          toggleSize: 13.0,
                          value: sellerMode,
                          borderRadius: 20.0,
                          showOnOff: false,
                          activeColor: ColorStyle.primaryColor,
                          inactiveColor: ColorStyle.secondaryTextColor,
                          onToggle: (val) {
                            _switchApps();
                          })
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(profileRoute);
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 2,
                        color: ColorStyle.secondaryTextColor.withOpacity(0.2),
                      )),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                            color: ColorStyle.primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: ColorStyle.secondaryTextColor,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(resetpassRoute);
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 2,
                        color: ColorStyle.secondaryTextColor.withOpacity(0.2),
                      )),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reset Password",
                        style: TextStyle(
                            color: ColorStyle.primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: ColorStyle.secondaryTextColor,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    notificationAllowed = !notificationAllowed;
                  });
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 2,
                        color: ColorStyle.secondaryTextColor.withOpacity(0.2),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Notifications",
                        style: TextStyle(
                            color: ColorStyle.primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      FlutterSwitch(
                          width: 40.0,
                          height: 20.0,
                          toggleSize: 13.0,
                          value: notificationAllowed,
                          borderRadius: 20.0,
                          showOnOff: false,
                          activeColor: ColorStyle.primaryColor,
                          inactiveColor: ColorStyle.secondaryTextColor,
                          onToggle: (val) {
                            setState(() {
                              notificationAllowed = val;
                            });
                          })
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(privacyRoute);
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 2,
                        color: ColorStyle.secondaryTextColor.withOpacity(0.2),
                      )),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Privacy Policy",
                        style: TextStyle(
                            color: ColorStyle.primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: ColorStyle.secondaryTextColor,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(termsRoute);
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 2,
                        color: ColorStyle.secondaryTextColor.withOpacity(0.2),
                      )),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Terms and Conditions",
                        style: TextStyle(
                            color: ColorStyle.primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: ColorStyle.secondaryTextColor,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  PrefUtils().setIsUserLoggedIn = false;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    roleSelectionRoute,
                    (e) => false,
                  );
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        width: 2,
                        color: ColorStyle.secondaryTextColor.withOpacity(0.2),
                      )),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Sign Out",
                        style: TextStyle(
                            color: ColorStyle.primaryColorLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        Icons.logout,
                        color: ColorStyle.primaryColorLight,
                        size: 19,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
