import 'package:eventify/styles/color_style.dart';
import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class StepFourContainer extends StatefulWidget {
  const StepFourContainer({super.key});

  @override
  State<StepFourContainer> createState() => _StepFourContainerState();
}

class _StepFourContainerState extends State<StepFourContainer> {
  TextEditingController _capacityController = TextEditingController();
  TextEditingController _passesController = TextEditingController();

  String _groupValue = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () {
            setState(() {
              _groupValue = "free";
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border:
                  Border.all(color: ColorStyle.secondaryTextColor, width: 0.7),
            ),
            child: Row(
              children: [
                Radio(
                    value: "free",
                    groupValue: _groupValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _groupValue = value;
                        });
                      }
                    }),
                Text("This is a free event")
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () {
            setState(() {
              _groupValue = "paid";
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border:
                  Border.all(color: ColorStyle.secondaryTextColor, width: 0.7),
            ),
            child: Row(
              children: [
                Radio(
                    value: "paid",
                    groupValue: _groupValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _groupValue = value;
                        });
                      }
                    }),
                Text("This is a paid event")
              ],
            ),
          ),
        ),
        Visibility(
          visible: _groupValue == "paid",
          child: Column(
            children: [
              const SizedBox(height: 30),
              CustomTextField(
                  controller: _capacityController,
                  hint: "Starts From",
                  icon: const Icon(Icons.sell_outlined),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 30),
              CustomTextField(
                  controller: _passesController,
                  hint: "Goes Upto",
                  icon: const Icon(Icons.sell_outlined),
                  keyboardType: TextInputType.number),
              const SizedBox(height: 30),
            ],
          ),
        )
      ],
    );
  }
}
