import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

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
                  child: CustomRoundedButton("Continue", () {
                    Navigator.of(context).pushNamed(forgotPassTwoRoute);
                  },
                    roundedCorners: 12,
                    textWeight: FontWeight.bold,
                  ),
                )
              ],
            )));
  }
}
