import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  TextEditingController _passController = TextEditingController();
  TextEditingController _cpassController = TextEditingController();
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
          "Reset Password",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New password",
                  style: TextStyle(color: ColorStyle.secondaryTextColor),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _passController,
                  borderColor: ColorStyle.primaryTextColor,
                ),
                SizedBox(height: 20),
                Text(
                  "Confirm password",
                  style: TextStyle(color: ColorStyle.secondaryTextColor),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: _cpassController,
                  borderColor: ColorStyle.primaryTextColor,
                ),
                Spacer(),
                Container(
                    width: double.maxFinite,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 4),
                              blurRadius: 4,
                              color: ColorStyle.blackColor.withOpacity(0.25))
                        ]),
                    child: CustomRoundedButton(
                      'Reset',
                      () {
                        // PrefUtils().setIsUserLoggedIn = true;
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     mainRoute, arguments: MainArgs(0), (e) => false);
                      },
                      roundedCorners: 12,
                      textWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
