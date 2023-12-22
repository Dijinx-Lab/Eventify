import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordOneScreen extends StatefulWidget {
  const ForgotPasswordOneScreen({super.key});

  @override
  State<ForgotPasswordOneScreen> createState() =>
      _ForgotPasswordOneScreenState();
}

class _ForgotPasswordOneScreenState extends State<ForgotPasswordOneScreen> {
  TextEditingController _emailController = TextEditingController();
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
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: SvgPicture.asset(
                //       PrefUtils().getIsAppTypeCustomer
                //           ? 'assets/svgs/ic_eventify_client_logo.svg'
                //           : 'assets/svgs/ic_eventify_seller_logo.svg',
                //       width: 160),
                // ),
                const Text(
                  "Forgot Password?",
                  style: TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Please enter the email address associated with your account. We'll send you a verification code to reset your password",
                  style: TextStyle(
                    color: ColorStyle.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 35),
                CustomTextField(
                  hint: "Email",
                  autofocus: true,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icon(Icons.email_outlined),
                ),
                Spacer(),
                Container(
                  height: 50,
                  width: double.maxFinite,
                  child: CustomRoundedButton(
                    "Continue",
                    () {
                      ToastUtils.showCustomSnackbar(
                        context: context,
                        icon: Icon(
                          Icons.task_alt_outlined,
                          color: ColorStyle.whiteColor,
                        ),
                        contentText:
                            "Great! We've sent a verification code to your email. Please check your inbox and enter the code below to reset your password.",
                      );
                      Future.delayed(Duration(milliseconds: 200)).then((value) {
                        Navigator.of(context).pushNamed(forgotPassTwoRoute);
                      });
                    },
                    roundedCorners: 12,
                    textWeight: FontWeight.bold,
                  ),
                )
              ],
            )));
  }
}
