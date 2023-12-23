import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/role_selection_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/models/screen_args/splash_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  final SplashArgs? args;
  const SplashScreen({super.key, this.args});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    _moveToNextScreen();
    super.initState();
  }

  _moveToNextScreen() {
    Future.delayed(const Duration(milliseconds: 800)).then((value) {
      if (PrefUtils().getIsUserLoggedIn) {
        if (PrefUtils().getIsAppTypeCustomer) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              mainRoute, arguments: MainArgs(0), (e) => false);
        } else {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(sellerHomeRoute, (e) => false);
        }
      } else if (widget.args?.isFromProfile ?? false) {
        PrefUtils().getIsAppTypeCustomer;
        Navigator.of(context).pushNamedAndRemoveUntil(signupRoute, (e) => false,
            arguments: SignupArgs(PrefUtils().getIsAppTypeCustomer, false));
      } else if (PrefUtils().getIsUserOnboarded) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          roleSelectionRoute,
          arguments: RoleSelectionArgs(null),
          (e) => false,
        );
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(onboardingOneRoute, (e) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PrefUtils().getIsAppTypeCustomer
          ? ColorStyle.whiteColor
          : ColorStyle.primaryColor,
      body: Center(
        child: SvgPicture.asset(
          PrefUtils().getIsAppTypeCustomer
              ? 'assets/svgs/ic_eventify_client_logo.svg'
              : 'assets/svgs/ic_eventify_seller_logo.svg',
          height: 70,
          width: 70,
        ),
      ),
    );
  }
}
