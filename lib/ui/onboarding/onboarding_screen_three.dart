import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/role_selection_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreenThree extends StatefulWidget {
  const OnboardingScreenThree({super.key});

  @override
  State<OnboardingScreenThree> createState() => _OnboardingScreenThreeState();
}

class _OnboardingScreenThreeState extends State<OnboardingScreenThree> {
  bool isAnimationTriggered = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1)).then((value) {
      setState(() {
        isAnimationTriggered = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text(
                  "Reach out to people for your event",
                  style: TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ultricies tristique orci, ut volutpat massa",
                  style: TextStyle(
                    color: ColorStyle.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: SvgPicture.asset(
                    'assets/svgs/onboarding_three.svg',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                _makeDots(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      PrefUtils().setIsUserOnboarded = true;
                      Navigator.of(context).pushNamed(signupRoute,
              arguments: SignupArgs(PrefUtils().getIsAppTypeCustomer, true));
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //     roleSelectionRoute,  arguments: RoleSelectionArgs(null),
                      //     (e) => false);
                    },
                    child: AnimatedContainer(
                      width: isAnimationTriggered
                          ? MediaQuery.of(context).size.width - 60
                          : 70,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 800),
                      decoration: BoxDecoration(
                          color: !isAnimationTriggered
                              ? ColorStyle.primaryColor.withOpacity(0)
                              : ColorStyle.primaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                                color: !isAnimationTriggered
                                    ? ColorStyle.whiteColor.withOpacity(0.25)
                                    : ColorStyle.blackColor.withOpacity(0.25))
                          ]),
                      child: const Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Get Started',
                              style: TextStyle(
                                  color: ColorStyle.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.arrow_forward,
                              color: ColorStyle.whiteColor,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _makeDots() {
    return Row(children: [
      Container(
        height: 9,
        width: 9,
        decoration: const BoxDecoration(
          color: ColorStyle.primaryColorExtraLight,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 6),
      Container(
        height: 9,
        width: 9,
        decoration: const BoxDecoration(
          color: ColorStyle.primaryColorExtraLight,
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 6),
      Container(
        height: 12,
        width: 12,
        decoration: const BoxDecoration(
          color: ColorStyle.primaryColorLight,
          shape: BoxShape.circle,
        ),
      ),
    ]);
  }
}
