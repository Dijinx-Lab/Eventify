import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingScreenOne extends StatefulWidget {
  const OnboardingScreenOne({super.key});

  @override
  State<OnboardingScreenOne> createState() => _OnboardingScreenOneState();
}

class _OnboardingScreenOneState extends State<OnboardingScreenOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(),
              const Text(
                "Discover events all around you",
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
              SvgPicture.asset(
                'assets/svgs/onboarding_one.svg',
                height: 300,
                fit: BoxFit.contain,
              ),
              _makeDots(),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(onboardingTwoRoute);
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                        color: ColorStyle.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              color: ColorStyle.blackColor.withOpacity(0.25))
                        ]),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: ColorStyle.whiteColor,
                      size: 35,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  _makeDots() {
    return Row(children: [
      Container(
        height: 12,
        width: 12,
        decoration: const BoxDecoration(
          color: ColorStyle.primaryColorLight,
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
        height: 9,
        width: 9,
        decoration: const BoxDecoration(
          color: ColorStyle.primaryColorExtraLight,
          shape: BoxShape.circle,
        ),
      )
    ]);
  }
}
