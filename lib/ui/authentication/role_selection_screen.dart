import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/user_response/user_response.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/services/user_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  void initState() {
    super.initState();
  }

  _updateProfile(pref) async {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(builder: (_) => const LoadingUtil(type: 2));
    UserService()
        .updateProfile(null, null, null, null, null, null, pref, null)
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        UserResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          PrefUtils().setAppPreference =
              apiResponse.data?.user?.appSidePreference ?? "new";
          ToastUtils.showCustomSnackbar(
            context: context,
            contentText: "Welcome to Event Bazaar",
            icon: const Icon(
              Icons.celebration_outlined,
              color: ColorStyle.whiteColor,
            ),
          );
          _navigatorFunction();
        } else {}
      } else {}
    });
  }

  _navigatorFunction() {
    if (PrefUtils().getAppPreference == "new") {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(roleSelectionRoute, (e) => false);
    } else if (PrefUtils().getAppPreference == "viewer") {
      Navigator.of(context).pushNamedAndRemoveUntil(
          mainRoute, arguments: MainArgs(0), (e) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(sellerHomeRoute, (e) => false);
    }
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
                onTap: () => _updateProfile('viewer'),
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
                onTap: () => _updateProfile('lister'),
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
