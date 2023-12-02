import 'package:eventify/models/screen_args/create_event_args.dart';
import 'package:eventify/styles/color_style.dart';
import 'package:eventify/ui/seller/create_event/step_five/create_event_step_five.dart';
import 'package:eventify/ui/seller/create_event/step_four/create_event_step_four.dart';
import 'package:eventify/ui/seller/create_event/step_one/create_event_step_one.dart';
import 'package:eventify/ui/seller/create_event/step_seven/create_event_step_seven.dart';
import 'package:eventify/ui/seller/create_event/step_six/create_event_step_six.dart';
import 'package:eventify/ui/seller/create_event/step_three/create_event_step_three.dart';
import 'package:eventify/ui/seller/create_event/step_two/create_event_step_two.dart';
import 'package:eventify/widgets/custom_rounded_button.dart';
import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  final CreateEventsArgs args;
  const CreateEventScreen({super.key, required this.args});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  int stepperIndex = 0;

  List<String> titles = [
    "When is it going to happen?",
    "Where is it going to happen?",
    "How much space is there?",
    "What is the price range for your pass?",
    "Have a name and photo for your event?",
    "Want to describe your event to attendees?",
    "Where should we contact for inquiries?"
  ];

  List<Widget> steps = const [
    StepOneContainer(),
    StepTwoContainer(),
    StepThreeContainer(),
    StepFourContainer(),
    StepFiveContainer(),
    StepSixContainer(),
    StepSevenContainer()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (stepperIndex > 0) {
          stepperIndex--;
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorStyle.whiteColor,
            foregroundColor: ColorStyle.secondaryTextColor,
            elevation: 0.5,
            title: const Text(
              "Upload Event",
              style: TextStyle(
                  color: ColorStyle.primaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              onPressed: () {
                if (stepperIndex == 0) {
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    stepperIndex--;
                  });
                }
              },
              icon: const Icon(
                Icons.arrow_back,
                color: ColorStyle.secondaryTextColor,
              ),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles[stepperIndex],
                  style: const TextStyle(
                      color: ColorStyle.primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: steps[stepperIndex],
                  ),
                ),
                const SizedBox(height: 20),
                _stepperIndicator(),
                const SizedBox(height: 15),
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
                      'Continue',
                      () {
                        if (stepperIndex < 6) {
                          setState(() {
                            stepperIndex++;
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
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

  _stepperIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 0
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 0
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 0,
            child: const Text(
              "1",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 1
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 1
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 1
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 1,
            child: const Text(
              "2",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 2
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 2
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 2
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 2,
            child: const Text(
              "3",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 3
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 3
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 3
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 3,
            child: const Text(
              "4",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 4
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 4
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 4
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 4,
            child: const Text(
              "5",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 5
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 5
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 5
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 5,
            child: const Text(
              "6",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
        const SizedBox(width: 2),
        Container(
          width: 20,
          height: 2,
          color: stepperIndex >= 6
              ? ColorStyle.primaryColorLight
              : ColorStyle.cardColor,
        ),
        const SizedBox(width: 2),
        AnimatedContainer(
          height: 25,
          width: 25,
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: stepperIndex >= 6
                      ? ColorStyle.primaryColor
                      : ColorStyle.cardColor),
              color: stepperIndex >= 6
                  ? ColorStyle.primaryColorLight
                  : ColorStyle.cardColor),
          child: Center(
              child: Visibility(
            visible: stepperIndex == 6,
            child: const Text(
              "7",
              style: TextStyle(
                  color: ColorStyle.whiteColor, fontWeight: FontWeight.bold),
            ),
          )),
        ),
      ],
    );
  }
}
