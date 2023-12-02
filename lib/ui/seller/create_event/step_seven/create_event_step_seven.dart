import 'dart:io';

import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class StepSevenContainer extends StatefulWidget {
  const StepSevenContainer({super.key});

  @override
  State<StepSevenContainer> createState() => _StepSevenContainerState();
}

class _StepSevenContainerState extends State<StepSevenContainer> {
  TextEditingController _firstController = TextEditingController();
  TextEditingController _secondController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _waController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool isPhotoTaken = false;
  String? imagePath;

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
    return Column(
      children: [
        const SizedBox(height: 30),
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
                      child: isPhotoTaken
                          ? SizedBox(
                              height: 70,
                              width: 70,
                              child: Image.file(
                                File(imagePath!),
                                fit: BoxFit.cover,
                              ))
                          : SizedBox(
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
                          borderRadius: BorderRadius.circular(6)),
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
        const SizedBox(height: 40),
        CustomTextField(
          controller: _firstController,
          hint: "First name",
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: _secondController,
          hint: "Last name",
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: _phoneController,
          hint: "Phone number",
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: _waController,
          hint: "Whatsapp number",
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: _emailController,
          hint: "Email",
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 30),
      ],
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
