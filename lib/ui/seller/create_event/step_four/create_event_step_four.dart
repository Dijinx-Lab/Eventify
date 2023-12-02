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
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
