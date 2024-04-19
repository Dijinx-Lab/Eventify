import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/user_response/user_detail.dart';
import 'package:eventify/models/api_models/user_response/user_response.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/models/screen_args/splash_args.dart';
import 'package:eventify/services/user_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  final SplashArgs? args;
  const SplashScreen({super.key, this.args});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserService userService = UserService();

  @override
  initState() {
    if (PrefUtils().getIsUserLoggedIn) {
      _refreshUserDetails();
    } else {
      _moveToNextScreen();
    }
    super.initState();
  }

  _moveToNextScreen() {
    Future.delayed(const Duration(milliseconds: 1500)).then((value) {
      if (PrefUtils().getIsUserLoggedIn) {
        if (PrefUtils().getIsAppTypeCustomer) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              mainRoute,
              arguments: widget.args?.mainArgs ?? MainArgs(0),
              (e) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(sellerHomeRoute, (e) => false);
        }
      } else if (widget.args?.isFromProfile ?? false) {
        Navigator.of(context).pushNamedAndRemoveUntil(signupRoute, (e) => false,
            arguments: SignupArgs(PrefUtils().getIsAppTypeCustomer, false));
      } else if (PrefUtils().getIsUserOnboarded) {
        Navigator.of(context).pushNamedAndRemoveUntil(signupRoute, (e) => false,
            arguments: SignupArgs(PrefUtils().getIsAppTypeCustomer, false));
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(onboardingOneRoute, (e) => false);
      }
    });
  }

  _refreshUserDetails() async {
    _moveToNextScreen();
    userService.getDetails().then((value) async {
      if (value.error == null) {
        UserResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          _saveUserData(apiResponse.data!.user!, loggedIn: true);
        }
      } else if (value.error == "401") {
        PrefUtils().setIsUserLoggedIn = false;
        ToastUtils.showCustomSnackbar(
          context: context,
          contentText: "Your session has expired",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  _saveUserData(UserDetail userDetail, {bool loggedIn = true}) {
    //print(userDetail.authToken);
    PrefUtils().setFirstName = userDetail.firstName ?? "";
    PrefUtils().setLasttName = userDetail.lastName ?? "";
    PrefUtils().setAge = int.tryParse(userDetail.age ?? '0') ?? 0;
    PrefUtils().setCountryCode = userDetail.countryCode ?? "";
    PrefUtils().setPhone = userDetail.phone ?? "";
    PrefUtils().setEmail = userDetail.email ?? "";
    PrefUtils().setToken = userDetail.authToken ?? "";
    PrefUtils().setIsUserLoggedIn = loggedIn;
    PrefUtils().setNotificationsEnabled =
        userDetail.notificationsEnabled ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrefUtils().getIsAppTypeCustomer
          ? ColorStyle.whiteColor
          : ColorStyle.primaryColor,
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: SvgPicture.asset(
            PrefUtils().getIsAppTypeCustomer
                ? 'assets/svgs/ic_eventify_client_logo.svg'
                : 'assets/svgs/ic_eventify_seller_logo.svg',
          ),
        ),
      ),
    );
  }
}
