import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/models/screen_args/splash_args.dart';
import 'package:eventify/services/user_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/auth_util.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/avatars/name_avatar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  bool sellerMode = false;
  bool notificationAllowed = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  initState() {
    notificationAllowed = PrefUtils().getNotificationsEnabled;
    super.initState();
  }

  Future<String?> _getFcmToken() async {
    await _firebaseMessaging.requestPermission();
    return await _firebaseMessaging.getToken();
  }

  _switchApps() {
    setState(() {
      sellerMode = !sellerMode;
    });
    Future.delayed(const Duration(milliseconds: 300)).then(
      (value) {
        if (PrefUtils().getIsAppTypeCustomer) {
          PrefUtils().setIsAppTypeCustomer = false;
        } else {
          PrefUtils().setIsAppTypeCustomer = true;
        }

        Navigator.of(context).pushNamedAndRemoveUntil(
            initialRoute, (e) => false,
            arguments: SplashArgs(true, MainArgs(0)));
      },
    );
  }

  _signOutOfServer() {
    SmartDialog.showLoading(builder: (_) => const LoadingUtil(type: 2));
    UserService().signOut().then((value) async {
      if (value.error == null) {
        GenericResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          await _signOut();
        } else {
          SmartDialog.dismiss();
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
        SmartDialog.dismiss();
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

  _signOut() async {
    await AuthUtil.signOut();
    PrefUtils().setFirstName = "";
    PrefUtils().setLasttName = "";
    PrefUtils().setAge = 0;
    PrefUtils().setCountryCode = "";
    PrefUtils().setPhone = "";
    PrefUtils().setEmail = "";
    PrefUtils().setToken = "";
    PrefUtils().setIsUserLoggedIn = false;
    PrefUtils().setIsAppTypeCustomer = true;
    PrefUtils().lastBrand = "";
    SmartDialog.dismiss();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(signupRoute, (e) => false,
          arguments: SignupArgs(PrefUtils().getIsAppTypeCustomer, false));
    }
  }

  _updateNotificationSettings() async {
    if (notificationAllowed) {
      await UserService()
          .updateProfile(null, null, null, null, null, "x", null, null);
      PrefUtils().setNotificationsEnabled = false;
    } else {
      String? token = await _getFcmToken();
      await UserService()
          .updateProfile(null, null, null, null, null, token, null, null);
      PrefUtils().setNotificationsEnabled = true;
    }
    setState(() {
      notificationAllowed = !notificationAllowed;
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
              NameAvatar(
                  firstName: PrefUtils().getFirstName,
                  lastName: PrefUtils().getLasttName),
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(200),
              //   child: Center(
              //     child: SizedBox(
              //         height: 70,
              //         width: 70,
              //         child: Image.asset(
              //           "assets/pngs/image_placeholder.png",
              //           fit: BoxFit.cover,
              //         )),
              //   ),
              // ),
              const SizedBox(height: 10),
              const Text(
                "", // "${PrefUtils().getUserFirstName} ${PrefUtils().getUserLastName}",
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
                            ? "Switch to viewer mode"
                            : "Switch to lister mode",
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
                child: Visibility(
                  visible: PrefUtils().getSignInMethod == "email" ||
                      PrefUtils().getSignInMethod == "phone",
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
                          "Change Password",
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
              ),
              GestureDetector(
                onTap: () {
                  _updateNotificationSettings();
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
                            _updateNotificationSettings();
                          })
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(alertsRoute);
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
                        "Alerts",
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
                  _signOutOfServer();
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
                      Text(
                        PrefUtils().getIsUserLoggedIn
                            ? "Sign Out"
                            : "Sign In to Eventify",
                        style: TextStyle(
                            color: PrefUtils().getIsUserLoggedIn
                                ? ColorStyle.primaryColorLight
                                : ColorStyle.primaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const Icon(
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
