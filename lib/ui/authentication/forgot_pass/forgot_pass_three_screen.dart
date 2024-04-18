import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/user_response/user_detail.dart';
import 'package:eventify/models/api_models/user_response/user_response.dart';
import 'package:eventify/models/screen_args/forgot_pass_args.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/services/user_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ForgotPasswordThreeScreen extends StatefulWidget {
  final ForgotPassArgs arguments;
  const ForgotPasswordThreeScreen({super.key, required this.arguments});

  @override
  State<ForgotPasswordThreeScreen> createState() =>
      _ForgotPasswordThreeScreenState();
}

class _ForgotPasswordThreeScreenState extends State<ForgotPasswordThreeScreen> {
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _confPwdController = TextEditingController();

  _forgotPassword() async {
    SmartDialog.showLoading(builder: (_) => const LoadingUtil(type: 2));
    UserService()
        .forgotPassword(widget.arguments.email, _pwdController.text.trim(),
            _confPwdController.text.trim())
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        UserResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          ToastUtils.showCustomSnackbar(
            context: context,
            millisecond: 5000,
            icon: const Icon(
              Icons.celebration_outlined,
              color: ColorStyle.whiteColor,
            ),
            contentText:
                "Congratulations! Your password has been updated successfully.",
          );
          _saveUserData(apiResponse.data!.user!);
          Future.delayed(const Duration(milliseconds: 600)).then(
            (value) {
              _navigatorFunction();
            },
          );
        } else {
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
        ToastUtils.showCustomSnackbar(
          context: context,
          contentText: value.error ?? "",
          icon: const Icon(
            Icons.cancel_outlined,
            color: ColorStyle.whiteColor,
          ),
        );
      }
    });
  }

  _navigatorFunction() {
    if (PrefUtils().getIsAppTypeCustomer) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          mainRoute, arguments: MainArgs(0), (e) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(sellerHomeRoute, (e) => false);
    }
  }

  _saveUserData(UserDetail userDetail, {bool loggedIn = true}) {
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

  bool isPwdVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: ColorStyle.whiteColor,
          foregroundColor: ColorStyle.secondaryTextColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: ColorStyle.secondaryTextColor,
            ),
          ),
          // title: const Text(
          //   "Forgot Password",
          //   style: TextStyle(
          //       color: ColorStyle.primaryTextColor,
          //       fontSize: 16,
          //       fontWeight: FontWeight.bold),
          // ),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: SvgPicture.asset(
                //       PrefUtils().getIsAppTypeCustomer
                //           ? 'assets/svgs/ic_eventify_client_logo.svg'
                //           : 'assets/svgs/ic_eventify_seller_logo.svg',
                //       width: 160),
                // ),
                const Text(
                  "Set New Password",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "You're almost there! Choose a new password for your account. Make sure it's strong and unique.",
                  style: TextStyle(
                    color: ColorStyle.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 35),
                CustomTextField(
                    hint: "Password",
                    autofocus: true,
                    controller: _pwdController,
                    keyboardType: TextInputType.name,
                    icon: const Icon(Icons.lock_outline),
                    obscuretext: !isPwdVisible,
                    trailing: IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            isPwdVisible = !isPwdVisible;
                          });
                        },
                        icon: Icon(isPwdVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined))),
                const SizedBox(height: 30),
                CustomTextField(
                    hint: "Confirm Password",
                    autofocus: true,
                    controller: _confPwdController,
                    keyboardType: TextInputType.name,
                    icon: const Icon(Icons.lock_outline),
                    obscuretext: !isPwdVisible,
                    trailing: IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            isPwdVisible = !isPwdVisible;
                          });
                        },
                        icon: Icon(isPwdVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined))),
                const Spacer(),
                SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: CustomRoundedButton(
                    "Continue",
                    () => _forgotPassword(),
                    roundedCorners: 12,
                    textWeight: FontWeight.bold,
                  ),
                )
              ],
            )));
  }
}
