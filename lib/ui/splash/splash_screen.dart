import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
      Navigator.of(context)
          .pushNamedAndRemoveUntil(onboardingOneRoute, (e) => false);
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
