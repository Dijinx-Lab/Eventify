import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/api_models/generic_response/generic_response.dart';
import 'package:eventify/models/screen_args/forgot_pass_args.dart';
import 'package:eventify/services/user_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ForgotPasswordOneScreen extends StatefulWidget {
  const ForgotPasswordOneScreen({super.key});

  @override
  State<ForgotPasswordOneScreen> createState() =>
      _ForgotPasswordOneScreenState();
}

class _ForgotPasswordOneScreenState extends State<ForgotPasswordOneScreen> {
  final TextEditingController _emailController = TextEditingController();

  _sendOtp() async {
    setState(() {});
    SmartDialog.showLoading(builder: (_) => const LoadingUtil(type: 2));
    UserService()
        .sendOtp('password', _emailController.text.trim())
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        GenericResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          ToastUtils.showCustomSnackbar(
            context: context,
            icon: const Icon(
              Icons.task_alt_outlined,
              color: ColorStyle.whiteColor,
            ),
            contentText:
                "Great! We've sent a verification code to your email. Please check your inbox and enter the code below to update your password.",
          );
          Future.delayed(const Duration(milliseconds: 200)).then((value) {
            Navigator.of(context).pushNamed(forgotPassTwoRoute,
                arguments: ForgotPassArgs(email: _emailController.text.trim()));
          });
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
                  "Forgot Password?",
                  style: TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Please enter the email address associated with your account. We'll send you a verification code to update your password",
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
                  icon: const Icon(Icons.email_outlined),
                ),
                const Spacer(),
                SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: CustomRoundedButton(
                    "Continue",
                    () => _sendOtp(),
                    roundedCorners: 12,
                    textWeight: FontWeight.bold,
                  ),
                )
              ],
            )));
  }
}
