import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class StepSixContainer extends StatefulWidget {
  const StepSixContainer({super.key});

  @override
  State<StepSixContainer> createState() => _StepSixContainerState();
}

class _StepSixContainerState extends State<StepSixContainer> {
  TextEditingController _capacityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        CustomTextField(
          controller: _capacityController,
          hint: "Description",
          keyboardType: TextInputType.name,
          maxLines: 6,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
