import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class StepFiveContainer extends StatefulWidget {
  const StepFiveContainer({super.key});

  @override
  State<StepFiveContainer> createState() => _StepFiveContainerState();
}

class _StepFiveContainerState extends State<StepFiveContainer> {
  TextEditingController _capacityController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool isPhotoTaken = false;
  String? imagePath;

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
        GestureDetector(
          onTap: () {
            openImages();
          },
          child: isPhotoTaken
              ? SizedBox(
                  height: 165,
                  child: Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 150,
                            width: double.maxFinite,
                            child: Image.file(
                              File(imagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPhotoTaken = false;
                              imagePath = null;
                            });
                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorStyle.cardColor),
                              child: const Icon(
                                Icons.close,
                                color: ColorStyle.secondaryTextColor,
                              )),
                        ),
                      )
                    ],
                  ),
                )
              : DottedBorder(
                  radius: const Radius.circular(12),
                  borderType: BorderType.RRect,
                  color: ColorStyle.secondaryTextColor,
                  dashPattern: [5, 3, 5, 3],
                  strokeCap: StrokeCap.butt,
                  child: Container(
                    height: 150,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: ColorStyle.cardColor),
                    child: const Center(
                      child: Text(
                        "Upload Image",
                        style: TextStyle(
                            color: ColorStyle.secondaryTextColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 30),
        CustomTextField(
            controller: _capacityController,
            hint: "Name",
            icon: null,
            keyboardType: TextInputType.name),
        const SizedBox(height: 30),
      ],
    );
  }
}
