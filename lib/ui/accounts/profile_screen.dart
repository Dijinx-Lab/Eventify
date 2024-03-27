import 'dart:io';

import 'package:eventify/styles/color_style.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final ImagePicker _picker = ImagePicker();
  bool isPhotoTaken = false;
  String? imagePath;

  @override
  void initState() {
    // _firstNameController.text = PrefUtils().getUserFirstName;
    // _lastNameController.text = PrefUtils().getUserLastName;
    // _emailController.text = PrefUtils().getUserEmail;
    // _phoneController.text = PrefUtils().getUserPhone;
    super.initState();
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
      }
    }
  }

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
          "Profile",
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                _openOptionsSheet();
                              },
                              child: SizedBox(
                                height: 70,
                                width: 70,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: Center(
                                        child: SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: Image.asset(
                                              "assets/pngs/image_placeholder.png",
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color: ColorStyle.primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: const Icon(
                                          Icons.edit,
                                          color: ColorStyle.whiteColor,
                                          size: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        "First name",
                        style: TextStyle(color: ColorStyle.secondaryTextColor),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _firstNameController,
                        borderColor: ColorStyle.primaryTextColor,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Last name",
                        style: TextStyle(color: ColorStyle.secondaryTextColor),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _lastNameController,
                        borderColor: ColorStyle.primaryTextColor,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Email",
                        style: TextStyle(color: ColorStyle.secondaryTextColor),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _emailController,
                        borderColor: ColorStyle.primaryTextColor,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Phone",
                        style: TextStyle(color: ColorStyle.secondaryTextColor),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _phoneController,
                        borderColor: ColorStyle.primaryTextColor,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 50,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 4),
                        blurRadius: 4,
                        color: ColorStyle.blackColor.withOpacity(0.25))
                  ]),
              child: CustomRoundedButton(
                'Save',
                () {
                  // PrefUtils().setIsUserLoggedIn = true;
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     mainRoute, arguments: MainArgs(0), (e) => false);
                },
                roundedCorners: 12,
                textWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
