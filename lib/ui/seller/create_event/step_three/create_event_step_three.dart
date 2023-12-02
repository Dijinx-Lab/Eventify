import 'package:eventify/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class StepThreeContainer extends StatefulWidget {
  const StepThreeContainer({super.key});

  @override
  State<StepThreeContainer> createState() => _StepThreeContainerState();
}

class _StepThreeContainerState extends State<StepThreeContainer> {
  TextEditingController _capacityController = TextEditingController();
  TextEditingController _passesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        CustomTextField(
            controller: _capacityController,
            hint: "Capacity",
            icon: const Icon(Icons.groups_outlined),
            keyboardType: TextInputType.number),
        const SizedBox(height: 30),
        CustomTextField(
            controller: _passesController,
            hint: "Passes Left",
            icon: const Icon(Icons.badge_outlined),
            keyboardType: TextInputType.number),
        const SizedBox(height: 30),
      ],
    );
  }
}
