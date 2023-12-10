import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class StepSixContainer extends StatefulWidget {
  const StepSixContainer({super.key});

  @override
  State<StepSixContainer> createState() => _StepSixContainerState();
}

class _StepSixContainerState extends State<StepSixContainer> {
  TextEditingController _capacityController = TextEditingController();

  List<String> categories = ["Concert", "Educational", "Entertainment"];

  String selectedCategory = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        CustomTextField(
          controller: _capacityController,
          hint: "Description",
          keyboardType: TextInputType.name,
          maxLines: 6,
        ),
        const SizedBox(height: 30),
        const Text(
          "Categories",
          style: TextStyle(
              color: ColorStyle.primaryTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        Column(
          children: categories
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = e;
                    });
                  },
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      width: double.maxFinite,
                      height: 60,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: selectedCategory == e
                                ? ColorStyle.primaryColor
                                : ColorStyle.secondaryTextColor,
                            width: 0.7),
                      ),
                      child: Row(children: [
                        Radio(
                            value: e,
                            groupValue: selectedCategory,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedCategory = e;
                                });
                              }
                            }),
                        Text(
                          e,
                          style: TextStyle(
                              fontSize: 16,
                              color: selectedCategory == e
                                  ? ColorStyle.primaryColor
                                  : ColorStyle.secondaryTextColor),
                        ),
                      ])),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
