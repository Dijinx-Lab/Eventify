import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/role_selection_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ForgotPasswordThreeScreen extends StatefulWidget {
  const ForgotPasswordThreeScreen({super.key});

  @override
  State<ForgotPasswordThreeScreen> createState() =>
      _ForgotPasswordThreeScreenState();
}

class _ForgotPasswordThreeScreenState extends State<ForgotPasswordThreeScreen> {
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _confPwdController = TextEditingController();
  bool isPwdVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                    icon: Icon(Icons.lock_outline),
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
                SizedBox(height: 30),
                CustomTextField(
                    hint: "Confirm Password",
                    autofocus: true,
                    controller: _confPwdController,
                    keyboardType: TextInputType.name,
                    icon: Icon(Icons.lock_outline),
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
                Spacer(),
                Container(
                  height: 50,
                  width: double.maxFinite,
                  child: CustomRoundedButton(
                    "Continue",
                    () {
                      ToastUtils.showCustomSnackbar(
                        context: context,
                        millisecond: 5000,
                        icon: const Icon(
                          Icons.celebration_outlined,
                          color: ColorStyle.whiteColor,
                        ),
                        contentText:
                            "Congratulations! Your password has been reset successfully. You can now log in with your new credentials",
                      );
                      Future.delayed(const Duration(milliseconds: 10)).then(
                          (value) => Navigator.of(context)
                                  .pushNamedAndRemoveUntil(roleSelectionRoute,
                                      arguments: RoleSelectionArgs(signupRoute),
                                      (e) {
                                return false;
                              }));
                    },
                    roundedCorners: 12,
                    textWeight: FontWeight.bold,
                  ),
                )
              ],
            )));
  }
}
