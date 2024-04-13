import 'package:eventify/models/api_models/user_response/user_response.dart';
import 'package:eventify/services/user_service.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/loading_utils.dart';
import 'package:eventify/utils/toast_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final TextEditingController _cpassController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _currentPassController = TextEditingController();

  _updateProfile() async {
    FocusManager.instance.primaryFocus?.unfocus();
    SmartDialog.showLoading(builder: (_) => const LoadingUtil(type: 2));
    UserService()
        .changePassword(
      _currentPassController.text.trim(),
      _passController.text.trim(),
      _cpassController.text.trim(),
    )
        .then((value) {
      SmartDialog.dismiss();
      if (value.error == null) {
        UserResponse apiResponse = value.snapshot;
        if (apiResponse.success ?? false) {
          ToastUtils.showCustomSnackbar(
            context: context,
            contentText: "Password updated",
            icon: const Icon(
              Icons.celebration_outlined,
              color: ColorStyle.whiteColor,
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          "Change Password",
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
                const Text(
                  "Current password",
                  style: TextStyle(color: ColorStyle.secondaryTextColor),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _currentPassController,
                  borderColor: ColorStyle.primaryTextColor,
                ),
                const SizedBox(height: 20),
                const Text(
                  "New password",
                  style: TextStyle(color: ColorStyle.secondaryTextColor),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _passController,
                  borderColor: ColorStyle.primaryTextColor,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Confirm password",
                  style: TextStyle(color: ColorStyle.secondaryTextColor),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _cpassController,
                  borderColor: ColorStyle.primaryTextColor,
                ),
                const Spacer(),
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
                      () => _updateProfile(),
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
