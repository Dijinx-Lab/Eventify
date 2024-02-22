import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/role_selection_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatefulWidget {
  final RoleSelectionArgs? args;
  const RoleSelectionScreen({super.key, this.args});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  void initState() {
    if (widget.args != null && widget.args!.nextRoute != null) {
      Future.delayed(const Duration(milliseconds: 10)).then((value) =>
          Navigator.of(context).pushNamed(widget.args!.nextRoute!,
              arguments: SignupArgs(PrefUtils().getIsAppTypeCustomer, false)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Text(
                "What are you looking for?",
                style: TextStyle(
                    color: ColorStyle.primaryTextColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  PrefUtils().setIsAppTypeCustomer = true;
                  Navigator.of(context).pushNamed(signupRoute,
                      arguments: SignupArgs(true, true));
                },
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: ColorStyle.primaryColor,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                            color: ColorStyle.blackColor.withOpacity(0.25))
                      ]),
                  child: const Row(children: [
                    Expanded(
                      child: Text(
                        'I am someone that is here to discover events',
                        style: TextStyle(
                            color: ColorStyle.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 50),
                    Icon(
                      Icons.travel_explore,
                      color: ColorStyle.whiteColor,
                      size: 55,
                    )
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  PrefUtils().setIsAppTypeCustomer = false;
                  Navigator.of(context).pushNamed(
                    signupRoute,
                    arguments: SignupArgs(false, true),
                  );
                },
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: ColorStyle.primaryColorLight,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                            color: ColorStyle.blackColor.withOpacity(0.25))
                      ]),
                  child: const Row(children: [
                    Expanded(
                      child: Text(
                        'I am someone looking to post events',
                        style: TextStyle(
                            color: ColorStyle.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(width: 50),
                    Icon(
                      Icons.post_add,
                      color: ColorStyle.whiteColor,
                      size: 55,
                    )
                  ]),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
