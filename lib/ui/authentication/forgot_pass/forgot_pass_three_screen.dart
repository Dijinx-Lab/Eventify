import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
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
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorStyle.whiteColor,
          foregroundColor: ColorStyle.secondaryTextColor,
          elevation: 0.5,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: ColorStyle.secondaryTextColor,
            ),
          ),
          title: const Text(
            "Forgot Password",
            style: TextStyle(
                color: ColorStyle.primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              children: [
                CustomTextField(
                  hint: "Password",
                  autofocus: true,
                  controller: _emailController,
                  keyboardType: TextInputType.name,
                  icon: Icon(Icons.lock_outline),
                ),
                SizedBox(height: 30),
                CustomTextField(
                  hint: "Confirm Password",
                  autofocus: true,
                  controller: _emailController,
                  keyboardType: TextInputType.name,
                  icon: Icon(Icons.lock_outline),
                ),
                Spacer(),
                Container(
                  height: 50,
                  width: double.maxFinite,
                  child: CustomRoundedButton(
                    "Continue",
                    () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          signupRoute,
                          arguments: SignupArgs(
                              PrefUtils().getIsAppTypeCustomer, false),
                          (e) => false);
                    },
                    roundedCorners: 12,
                    textWeight: FontWeight.bold,
                  ),
                )
              ],
            )));
  }
}
