import 'dart:io';

import 'package:eventify/constants/route_keys.dart';
import 'package:eventify/models/screen_args/main_args.dart';
import 'package:eventify/models/screen_args/signup_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SignUpScreen extends StatefulWidget {
  final SignupArgs args;
  const SignUpScreen({super.key, required this.args});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool isPwdVisible = false;
  bool isSignupSeleted = true;
  bool isTermsChecked = false;

  final ImagePicker picker = ImagePicker();
  final ImagePicker _picker = ImagePicker();
  bool isPhotoTaken = false;
  String? imagePath;

  @override
  void initState() {
    isSignupSeleted = widget.args.isSignupSelected;
    super.initState();
  }

  _resetFields() {
    setState(() {
      _emailController.text = "";
      _pwdController.text = "";
      _phoneController.text = "";
      _orgController.text = "";
      _firstNameController.text = "";
      _lastNameController.text = "";
      isSignupSeleted = !isSignupSeleted;
    });
  }

  _navigatorFunction() {
    PrefUtils().setIsUserLoggedIn = true;
    if (PrefUtils().getIsAppTypeCustomer) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          mainRoute, arguments: MainArgs(0), (e) => false);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(sellerHomeRoute, (e) => false);
    }
  }

  Future<void> openCamera() async {
    var status = await Permission.camera.request();
    XFile? xfile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
        preferredCameraDevice: CameraDevice.front);
    if (xfile != null && await File(xfile.path).exists()) {
      imagePath = xfile.path;
      if (mounted) {
        setState(() {
          isPhotoTaken = true;
        });
        _navigatorFunction();
      }
    }
  }

  Future<void> openImages() async {
    var status;
    if (Platform.isAndroid) {
      status = await Permission.storage.request();
    } else {
      status = await Permission.photos.request();
    }
    XFile? xfile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (xfile != null && await File(xfile.path).exists()) {
      imagePath = xfile.path;
      if (mounted) {
        setState(() {
          isPhotoTaken = true;
        });
        _navigatorFunction();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                      PrefUtils().getIsAppTypeCustomer
                          ? 'assets/svgs/login_ellipse.svg'
                          : 'assets/svgs/login_ellipse_alt.svg',
                      width: MediaQuery.of(context).size.width),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                          PrefUtils().getIsAppTypeCustomer
                              ? 'assets/svgs/ic_eventify_client_logo.svg'
                              : 'assets/svgs/ic_eventify_seller_logo.svg',
                          width: 160),
                    ),
                  ),
                  Positioned(
                    left: 15,
                    top: 50,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                            child: Icon(
                          Icons.arrow_back,
                          color: ColorStyle.whiteColor,
                          size: 30,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Builder(builder: (context) {
                          return GestureDetector(
                            onTap: _resetFields,
                            child: Column(
                              children: [
                                Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: isSignupSeleted
                                          ? ColorStyle.primaryTextColor
                                          : ColorStyle.secondaryTextColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                AnimatedContainer(
                                  height: 5,
                                  width: isSignupSeleted ? 65 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: isSignupSeleted
                                          ? ColorStyle.primaryColorLight
                                          : Colors.transparent),
                                )
                              ],
                            ),
                          );
                        }),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: _resetFields,
                          child: Column(
                            children: [
                              Text(
                                "Sign In",
                                style: TextStyle(
                                    color: !isSignupSeleted
                                        ? ColorStyle.primaryTextColor
                                        : ColorStyle.secondaryTextColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              AnimatedContainer(
                                height: 5,
                                width: !isSignupSeleted ? 65 : 0,
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: !isSignupSeleted
                                        ? ColorStyle.primaryColorLight
                                        : Colors.transparent),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 25),
                    Visibility(
                      visible: isSignupSeleted,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                              controller: _firstNameController,
                              hint: "First Name",
                              icon: const Icon(Icons.person_outline),
                              keyboardType: TextInputType.name),
                          const SizedBox(height: 10),
                          CustomTextField(
                              controller: _lastNameController,
                              hint: "Last Name",
                              icon: const Icon(Icons.person_outline),
                              keyboardType: TextInputType.name),
                          const SizedBox(height: 10),
                          CustomTextField(
                              controller: _phoneController,
                              hint: "Phone",
                              icon: const Icon(Icons.phone_outlined),
                              keyboardType: TextInputType.phone),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: PrefUtils().getIsAppTypeCustomer == false,
                            child: CustomTextField(
                                controller: _orgController,
                                hint: "Organization Name",
                                icon: const Icon(Icons.corporate_fare_outlined),
                                keyboardType: TextInputType.name),
                          ),
                          Visibility(
                            visible: PrefUtils().getIsAppTypeCustomer == false,
                            child: const SizedBox(height: 10),
                          )
                        ],
                      ),
                    ),
                    CustomTextField(
                        controller: _emailController,
                        hint: "Email",
                        icon: const Icon(Icons.email_outlined),
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 10),
                    CustomTextField(
                        controller: _pwdController,
                        hint: "Password",
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
                    Visibility(
                        visible: !isSignupSeleted,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            child: Text(
                              "Forgot Password",
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(forgotPassOneRoute);
                            },
                          ),
                        )),
                    Visibility(
                      visible: isSignupSeleted,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isTermsChecked = !isTermsChecked;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: isTermsChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isTermsChecked = !isTermsChecked;
                                  });
                                },
                              ),
                              const Text(
                                "I agree to the terms and conditions",
                                style: TextStyle(
                                    color: ColorStyle.primaryTextColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        width: double.maxFinite,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 4,
                                  color:
                                      ColorStyle.blackColor.withOpacity(0.25))
                            ]),
                        child: CustomRoundedButton(
                          isSignupSeleted ? 'Sign Up' : 'Sign In',
                          () async {
                            if (isSignupSeleted) {
                              bool selectImage = await SmartDialog.show(
                                  animationType: SmartAnimationType.fade,
                                  builder: (context) => _customDialog(context));

                              if (selectImage) {
                                _openOptionsSheet();
                              } else {
                                _navigatorFunction();
                              }
                            } else {
                              _navigatorFunction();
                            }
                          },
                          roundedCorners: 12,
                          textWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 15),
                    Center(
                      child: Visibility(
                        visible: PrefUtils().getIsAppTypeCustomer,
                        child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 4),
                                      blurRadius: 4,
                                      color: ColorStyle.blackColor
                                          .withOpacity(0.25))
                                ]),
                            child: CustomRoundedButton(
                              'Skip For Now',
                              () {
                                PrefUtils().setIsUserLoggedIn = false;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    mainRoute,
                                    arguments: MainArgs(0),
                                    (e) => false);
                              },
                              roundedCorners: 18,
                              textSize: 14,
                              textWeight: FontWeight.w500,
                              buttonBackgroundColor: ColorStyle.whiteColor,
                              borderColor: ColorStyle.secondaryTextColor,
                              textColor: ColorStyle.secondaryTextColor,
                            )),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: 100,
                          color: ColorStyle.secondaryTextColor,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'or sign in with',
                          style: TextStyle(
                              color: ColorStyle.secondaryTextColor,
                              fontSize: 10),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          height: 1,
                          width: 100,
                          color: ColorStyle.secondaryTextColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: ColorStyle.whiteColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 4),
                                      blurRadius: 4,
                                      color: ColorStyle.blackColor
                                          .withOpacity(0.25))
                                ]),
                            child: const Icon(
                              Icons.phone_outlined,
                              color: ColorStyle.secondaryTextColor,
                              size: 30,
                            )),
                        Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: ColorStyle.whiteColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 4,
                                    color:
                                        ColorStyle.blackColor.withOpacity(0.25))
                              ]),
                          child: SizedBox(
                            height: 10,
                            width: 10,
                            child: Image.asset(
                              'assets/pngs/google_logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: ColorStyle.whiteColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 4),
                                    blurRadius: 4,
                                    color: ColorStyle.blackColor
                                        .withOpacity(0.25)),
                              ]),
                          child: Image.asset(
                            'assets/pngs/apple_logo.png',
                            // height: 50,
                            // width: 50,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  _customDialog(context) {
    return Container(
      width: MediaQuery.of(context).size.width - 45,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: ColorStyle.whiteColor,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Profile Picture",
              style: TextStyle(
                  fontSize: 20,
                  color: ColorStyle.primaryColor,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 15),
            const Text(
              "Do you want to upload a profile picture?",
              style: TextStyle(color: ColorStyle.primaryTextColor),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomRoundedButton(
                      "Skip",
                      () {
                        SmartDialog.dismiss(result: false);
                      },
                      //roundedCorners: 18,
                      textSize: 14,
                      textWeight: FontWeight.w500,
                      buttonBackgroundColor: ColorStyle.whiteColor,
                      borderColor: ColorStyle.secondaryTextColor,
                      textColor: ColorStyle.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomRoundedButton(
                      "Upload",
                      () {
                        SmartDialog.dismiss(result: true);
                      },
                      //roundedCorners: 18,
                      textSize: 14,
                      textWeight: FontWeight.w500,
                      // buttonBackgroundColor: ColorStyle.whiteColor,
                      // borderColor: ColorStyle.secondaryTextColor,
                      // textColor: ColorStyle.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }

  _openOptionsSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: CupertinoActionSheet(
                actions: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await openCamera();
                    },
                    child: Container(
                        height: 60,
                        color: Colors.white,
                        child: Container(
                          // margin: const EdgeInsets.only(left: 25),
                          child: const Center(
                            child: Text("Camera",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorStyle.primaryTextColor)),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await openImages();
                    },
                    child: Container(
                        height: 60,
                        color: Colors.white,
                        child: const Center(
                          child: Text("Gallery",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorStyle.primaryTextColor)),
                        )),
                  ),
                ],
                cancelButton: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: ColorStyle.primaryColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Text("Cancel",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorStyle.whiteColor)),
                        ))),
              ),
            ));
  }
}
