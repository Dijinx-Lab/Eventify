import 'dart:io';

import 'package:eventify/models/screen_args/event_args.dart';
import 'package:eventify/utils/pref_utils.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepSevenContainer extends StatefulWidget {
  final EventArgs event;
  final Function(EventArgs, bool) onDataFilled;
  const StepSevenContainer(
      {super.key, required this.event, required this.onDataFilled});

  @override
  State<StepSevenContainer> createState() => _StepSevenContainerState();
}

class _StepSevenContainerState extends State<StepSevenContainer> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _waController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();

  bool isPhotoTaken = false;
  String? imagePath;
  late EventArgs eventArgs;

  @override
  void initState() {
    eventArgs = widget.event;
    if (eventArgs.eventId != null) {
      _nameController.text = eventArgs.contactName ?? "";
      _organizerController.text = eventArgs.contactOrganization ?? "";
      _phoneController.text = eventArgs.contactPhone ?? "";
      _waController.text = eventArgs.contactWhatsApp ?? "";
      _emailController.text = eventArgs.contactEmail ?? "";
    } else {
      _nameController.text =
          "${PrefUtils().getFirstName} ${PrefUtils().getLasttName}";
      _phoneController.text =
          "${PrefUtils().getCountryCode}${PrefUtils().getPhone}";
    }

    Future.delayed(const Duration(microseconds: 800)).then((value) {
      _alertParentWidget();
    });

    super.initState();

    _nameController.addListener(() {
      _alertParentWidget();
    });

    _phoneController.addListener(() {
      _alertParentWidget();
    });

    _waController.addListener(() {
      _alertParentWidget();
    });

    _emailController.addListener(() {
      _alertParentWidget();
    });

    _organizerController.addListener(() {
      _alertParentWidget();
    });
  }

  _alertParentWidget() async {
    if (_nameController.text != "" &&
        _phoneController.text != "" &&
        _waController.text != "" &&
        _emailController.text != "" &&
        _organizerController.text != "") {
      eventArgs.contactOrganization = _organizerController.text;
      eventArgs.contactPhone = _phoneController.text;
      eventArgs.contactWhatsApp = _waController.text;
      eventArgs.contactEmail = _emailController.text;
      eventArgs.contactName = _nameController.text;
      widget.onDataFilled(eventArgs, true);
    } else {
      widget.onDataFilled(eventArgs, false);
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
              //  _openOptionsSheet();
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
                  // Positioned(
                  //   bottom: 0,
                  //   right: 0,
                  //   child: Container(
                  //     height: 20,
                  //     width: 20,
                  //     decoration: BoxDecoration(
                  //         color: ColorStyle.primaryColor,
                  //         borderRadius: BorderRadius.circular(6)),
                  //     child: const Icon(
                  //       Icons.edit,
                  //       color: ColorStyle.whiteColor,
                  //       size: 12,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        // CustomTextField(
        //   controller: _firstController,
        //   hint: "First name",
        //   keyboardType: TextInputType.name,
        // ),
        // const SizedBox(height: 30),
        CustomTextField(
          controller: _nameController,
          hint: "Name",
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
        CustomTextField(
          controller: _organizerController,
          hint: "Event Organizer",
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}
