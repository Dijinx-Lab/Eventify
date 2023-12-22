import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pinput/pinput.dart';

class ForgotPasswordTwoScreen extends StatefulWidget {
  const ForgotPasswordTwoScreen({super.key});

  @override
  State<ForgotPasswordTwoScreen> createState() =>
      _ForgotPasswordTwoScreenState();
}

class _ForgotPasswordTwoScreenState extends State<ForgotPasswordTwoScreen> {
  TextEditingController _otpController = TextEditingController();
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
                  "Verification Code",
                  style: TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Enter the verification code sent to your email. If you haven't received it, click \"Resend Code\"",
                  style: TextStyle(
                    color: ColorStyle.secondaryTextColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Note: The email might take a few minutes to arrive. If you don't see it, check your spam folder",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: ColorStyle.secondaryTextColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 35),
                Pinput(
                  length: 5,
                  autofocus: true,
                  controller: _otpController,
                  defaultPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                    color: ColorStyle.cardColor,
                    borderRadius: BorderRadius.circular(8),
                  )),
                  //separator: const SizedBox(width: 12),
                  focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: ColorStyle.cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                          color: ColorStyle.whiteColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w600)),
                  submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: ColorStyle.primaryColorLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                          color: ColorStyle.whiteColor,
                          fontSize: 30,
                          fontWeight: FontWeight.w600)),
                  onClipboardFound: (value) {
                    _otpController.setText(value);
                  },
                  showCursor: true,
                  cursor: cursor,
                ),
                const SizedBox(height: 10),
                Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {
                          ToastUtils.showCustomSnackbar(
                              context: context,
                              icon: Icon(
                                Icons.task_alt_outlined,
                                color: ColorStyle.whiteColor,
                              ),
                              contentText: "Verification code has been resent");
                        },
                        child: const Text(
                          "Resend Code",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ))),
                const Spacer(),
                SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: CustomRoundedButton(
                    "Verify",
                    () {
                      if (_otpController.text.length == 5) {
                        Navigator.of(context).pushNamed(forgotPassThreeRoute);
                      }
                    },
                    roundedCorners: 12,
                    textWeight: FontWeight.bold,
                  ),
                ),
              ],
            )));
  }

  final defaultPinTheme = const PinTheme(
    width: 51230,
    height: 50,
    textStyle: TextStyle(
        color: Color.fromRGBO(70, 69, 66, 1),
        fontSize: 30,
        fontWeight: FontWeight.w400),
  );

  final cursor = Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: 21,
      height: 1,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(137, 146, 160, 1),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
